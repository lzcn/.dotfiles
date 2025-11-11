import Foundation
#if os(macOS)
import Darwin
#else
import Glibc
#endif

enum CLIError: LocalizedError {
    case missingArgument(String)
    case invalidValue(String)
    case fileNotFound(String)
    case ollamaNotInstalled
    case ollamaUnavailable(String)
    case translationFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingArgument(let message):
            return "Missing argument: \(message)"
        case .invalidValue(let message):
            return "Invalid value: \(message)"
        case .fileNotFound(let path):
            return "Input file not found: \(path)"
        case .ollamaNotInstalled:
            return "Ollama CLI not found. Install it from https://ollama.com/download."
        case .ollamaUnavailable(let details):
            return "Unable to reach the Ollama service: \(details)"
        case .translationFailed(let details):
            return "Translation failed: \(details)"
        }
    }
}

struct Config {
    var input: URL
    var output: URL?
    var chunkSize: Int
    var splitMode: SplitMode
    var model: String?
    var targetLanguage: String
    var instruction: String
    var temperature: Double
    var retries: Int
    var retryDelay: TimeInterval
    var endpoint: URL
}

enum SplitMode: String {
    case paragraph
    case line
    case raw
}

struct GenerateOptions: Codable {
    let temperature: Double
}

struct GeneratePayload: Codable {
    let model: String
    let prompt: String
    let options: GenerateOptions
    let stream: Bool
}

struct GenerateResponse: Codable {
    let response: String?
}

struct OllamaModelLine: Decodable {
    let name: String
    let size: Int64?
    let modified_at: String?
    let details: ModelDetails?
}

struct ModelDetails: Decodable {
    let parameter_size: String?
    let family: String?
}

struct ModelDisplayInfo {
    let name: String
    let description: String
}

private func runTranslator() throws {
    var config = try parseArguments()
    try ensureOllamaInstalled()
    let models = try fetchModels()

    if config.model == nil {
        guard !models.isEmpty else {
            throw CLIError.ollamaUnavailable("No models found. Run `ollama pull <model>` first.")
        }
        config.model = selectModel(from: models)
    }

    guard let chosenModel = config.model else {
        throw CLIError.invalidValue("Could not determine which model to use.")
    }

    let outputURL = try resolveOutputURL(inputURL: config.input, customOutput: config.output, targetLanguage: config.targetLanguage)
    let sourceText = try String(contentsOf: config.input, encoding: .utf8)
    let chunks = chunkText(sourceText, size: config.chunkSize, mode: config.splitMode)
    print("Split into \(chunks.count) chunks using model \(chosenModel).")
    try writeTranslation(chunks: chunks, config: config, model: chosenModel, outputURL: outputURL)
    print("Translation completed: \(outputURL.path)")
}

do {
    try runTranslator()
} catch {
    fputs("Error: \(error.localizedDescription)\n", stderr)
    exit(EXIT_FAILURE)
}

// MARK: - Argument parsing

private func parseArguments() throws -> Config {
    let defaultsInstruction = "Translate the following content faithfully into {target_language} while preserving Markdown structure, equations, and references:\n\n{chunk}"
    var args = CommandLine.arguments.dropFirst().makeIterator()
    var inputPath: String?
    var outputPath: String?
    var chunkSize = 1800
    var splitMode: SplitMode = .paragraph
    var model: String?
    var targetLanguage = "Chinese"
    var instruction = defaultsInstruction
    var temperature = 0.2
    var retries = 3
    var retryDelay: TimeInterval = 2.0
    var endpointString = "http://localhost:11434/api/generate"

    while let arg = args.next() {
        switch arg {
        case "--input":
            inputPath = args.next()
        case "--output":
            outputPath = args.next()
        case "--chunk-size":
            if let value = args.next(), let size = Int(value), size > 0 {
                chunkSize = size
            } else {
                throw CLIError.invalidValue("--chunk-size expects a positive integer")
            }
        case "--split-mode":
            if let value = args.next(), let mode = SplitMode(rawValue: value) {
                splitMode = mode
            } else {
                throw CLIError.invalidValue("--split-mode must be one of paragraph/line/raw")
            }
        case "--model":
            model = args.next()
        case "--target-language":
            if let value = args.next(), !value.isEmpty {
                targetLanguage = value
            }
        case "--instruction":
            instruction = args.next() ?? instruction
        case "--temperature":
            if let value = args.next(), let temp = Double(value) {
                temperature = temp
            } else {
                throw CLIError.invalidValue("--temperature expects a number")
            }
        case "--retries":
            if let value = args.next(), let retryCount = Int(value), retryCount >= 0 {
                retries = retryCount
            } else {
                throw CLIError.invalidValue("--retries expects a non-negative integer")
            }
        case "--retry-delay":
            if let value = args.next(), let delay = Double(value), delay >= 0 {
                retryDelay = delay
            } else {
                throw CLIError.invalidValue("--retry-delay expects a non-negative number")
            }
        case "--endpoint":
            if let value = args.next(), !value.isEmpty {
                endpointString = value
            }
        case "--help", "-h":
            printUsage()
            exit(EXIT_SUCCESS)
        default:
            throw CLIError.invalidValue("Unknown argument: \(arg)")
        }
    }

    guard let inputPath else {
        throw CLIError.missingArgument("--input <path>")
    }

    let inputURL = URL(fileURLWithPath: inputPath).standardizedFileURL
    guard FileManager.default.fileExists(atPath: inputURL.path) else {
        throw CLIError.fileNotFound(inputURL.path)
    }

    let outputURL = outputPath.map { URL(fileURLWithPath: $0).standardizedFileURL }
    guard let endpointURL = URL(string: endpointString) else {
        throw CLIError.invalidValue("Unable to parse endpoint: \(endpointString)")
    }

    return Config(
        input: inputURL,
        output: outputURL,
        chunkSize: chunkSize,
        splitMode: splitMode,
        model: model,
        targetLanguage: targetLanguage,
        instruction: instruction,
        temperature: temperature,
        retries: retries,
        retryDelay: retryDelay,
        endpoint: endpointURL
    )
}

private func printUsage() {
    let message = """
    Usage:
      swift run OllamaTranslator --input <file> [--output <file>] [--model <name>] [options...]

    Common options:
      --input             Source Markdown/text file to translate (required)
      --output            Output file path (default: input.<target><original extension>)
      --model             Ollama model name (interactive picker if omitted)
      --target-language   Target language (default: Chinese)
      --chunk-size        Max characters per chunk, default 1800
      --split-mode        paragraph / line / raw
      --temperature       Sampling temperature, default 0.2
      --retries           Max retries per chunk, default 3
      --retry-delay       Base delay between retries in seconds, default 2
      --endpoint          Ollama generate API, default http://localhost:11434/api/generate
      --instruction       Custom prompt template with {target_language} and {chunk}

    Example:
      swift run OllamaTranslator --input book.md --target-language Chinese
    """
    print(message)
}

// MARK: - Ollama helpers

private func ensureOllamaInstalled() throws {
    let result = try runProcess(executable: "/usr/bin/env", arguments: ["which", "ollama"])
    if result.status != 0 || result.output.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        throw CLIError.ollamaNotInstalled
    }
}

private func fetchModels() throws -> [ModelDisplayInfo] {
    let jsonResult = try runProcess(executable: "/usr/bin/env", arguments: ["ollama", "list", "--json"])
    if jsonResult.status == 0 {
        let lines = jsonResult.output.split(whereSeparator: \.isNewline).map(String.init)
        var models: [ModelDisplayInfo] = []
        let decoder = JSONDecoder()
        for line in lines where !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let data = line.data(using: .utf8) else { continue }
            if let modelLine = try? decoder.decode(OllamaModelLine.self, from: data) {
                let sizeDescription: String
                if let bytes = modelLine.size {
                    sizeDescription = humanReadableSize(bytes: bytes)
                } else {
                    sizeDescription = "unknown size"
                }
                let parameter = modelLine.details?.parameter_size ?? ""
                var desc = "\(sizeDescription)"
                if !parameter.isEmpty {
                    desc += " · \(parameter)"
                }
                models.append(ModelDisplayInfo(name: modelLine.name, description: desc))
            }
        }
        return models
    }

    let unknownFlag = jsonResult.error.localizedCaseInsensitiveContains("unknown flag")
        || jsonResult.output.localizedCaseInsensitiveContains("unknown flag")
    if unknownFlag {
        let plainResult = try runProcess(executable: "/usr/bin/env", arguments: ["ollama", "list"])
        guard plainResult.status == 0 else {
            throw CLIError.ollamaUnavailable(plainResult.error.isEmpty ? plainResult.output : plainResult.error)
        }
        return parsePlainModelList(plainResult.output)
    }

    throw CLIError.ollamaUnavailable(jsonResult.error.isEmpty ? jsonResult.output : jsonResult.error)
}

private func parsePlainModelList(_ output: String) -> [ModelDisplayInfo] {
    var lines = output.split(whereSeparator: \.isNewline).map { String($0).trimmingCharacters(in: .whitespaces) }
    lines = lines.filter { !$0.isEmpty }
    if let first = lines.first, first.lowercased().hasPrefix("name") {
        lines.removeFirst()
    }
    var models: [ModelDisplayInfo] = []
    for line in lines {
        let parts = line.split(omittingEmptySubsequences: true, whereSeparator: { $0.isWhitespace })
        guard let name = parts.first else { continue }
        let desc = parts.dropFirst().joined(separator: " ")
        models.append(ModelDisplayInfo(name: String(name), description: desc.isEmpty ? "unknown size" : desc))
    }
    return models
}

private func selectModel(from models: [ModelDisplayInfo]) -> String {
    guard isatty(STDIN_FILENO) == 1, isatty(STDOUT_FILENO) == 1 else {
        if let fallback = models.first {
            print("Model not specified and terminal is non-interactive, defaulting to \(fallback.name)")
            return fallback.name
        }
        fatalError("No model available")
    }
    let menu = TerminalMenu(items: models)
    return menu.interactiveSelection()
}

// MARK: - Translation flow

private func chunkText(_ text: String, size: Int, mode: SplitMode) -> [String] {
    guard size > 0 else { return [] }
    if mode == .raw {
        return stride(from: 0, to: text.count, by: size).map { start in
            let end = min(text.count, start + size)
            let startIndex = text.index(text.startIndex, offsetBy: start)
            let endIndex = text.index(text.startIndex, offsetBy: end)
            return String(text[startIndex..<endIndex])
        }
    }

    let units: [String]
    let separator: String
    if mode == .line {
        units = text.components(separatedBy: .newlines)
        separator = "\n"
    } else {
        units = text.components(separatedBy: "\n\n")
        separator = "\n\n"
    }

    var chunks: [String] = []
    var buffer: [String] = []
    var currentLength = 0
    let sepLength = separator.count

    for unit in units {
        let trimmedUnit = unit
        if !buffer.isEmpty, currentLength + trimmedUnit.count + sepLength > size {
            chunks.append(buffer.joined(separator: separator).trimmingCharacters(in: .whitespacesAndNewlines))
            buffer = [trimmedUnit]
            currentLength = trimmedUnit.count
        } else {
            buffer.append(trimmedUnit)
            currentLength += trimmedUnit.count + sepLength
        }
    }
    if !buffer.isEmpty {
        chunks.append(buffer.joined(separator: separator).trimmingCharacters(in: .whitespacesAndNewlines))
    }
    return chunks.filter { !$0.isEmpty }
}

private func resolveOutputURL(inputURL: URL, customOutput: URL?, targetLanguage: String) throws -> URL {
    if let custom = customOutput {
        let parent = custom.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: parent.path) {
            try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)
        }
        return custom
    }

    let directory = inputURL.deletingLastPathComponent()
    let baseName = inputURL.deletingPathExtension().lastPathComponent
    let extensionPart = inputURL.pathExtension.isEmpty ? "" : ".\(inputURL.pathExtension)"
    let fileName = "\(baseName).\(targetLanguage)\(extensionPart)"
    return directory.appendingPathComponent(fileName)
}

private func writeTranslation(chunks: [String], config: Config, model: String, outputURL: URL) throws {
    if FileManager.default.fileExists(atPath: outputURL.path) {
        try FileManager.default.removeItem(at: outputURL)
    }
    FileManager.default.createFile(atPath: outputURL.path, contents: nil)
    let handle = try FileHandle(forWritingTo: outputURL)
    defer {
        if #available(macOS 10.15, *) {
            try? handle.close()
        } else {
            handle.closeFile()
        }
    }

    if !chunks.isEmpty {
        renderProgress(current: 0, total: chunks.count)
    }

    for (index, chunk) in chunks.enumerated() {
        let translated = try translateChunk(
            chunk: chunk,
            config: config,
            model: model
        )
        let prefix = index == 0 ? "" : "\n\n"
        if let data = (prefix + translated).data(using: .utf8) {
            handle.write(data)
        }
        renderProgress(current: index + 1, total: chunks.count)
    }
}

private func translateChunk(chunk: String, config: Config, model: String) throws -> String {
    let prompt = config.instruction
        .replacingOccurrences(of: "{target_language}", with: config.targetLanguage)
        .replacingOccurrences(of: "{chunk}", with: chunk)

    let payload = GeneratePayload(
        model: model,
        prompt: prompt,
        options: GenerateOptions(temperature: config.temperature),
        stream: false
    )

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let payloadData = try encoder.encode(payload)
    var request = URLRequest(url: config.endpoint)
    request.httpMethod = "POST"
    request.httpBody = payloadData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    var lastError: Error?
    let maxAttempts = max(config.retries, 1)
    for attempt in 1...maxAttempts {
        do {
            let (data, response) = try URLSession.shared.syncRequest(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw CLIError.translationFailed("Received an invalid response.")
            }
            guard 200..<300 ~= http.statusCode else {
                let body = String(data: data, encoding: .utf8) ?? "unknown error"
                throw CLIError.translationFailed("Status code \(http.statusCode): \(body)")
            }
            let result = try decoder.decode(GenerateResponse.self, from: data)
            let trimmed = result.response?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if trimmed.isEmpty {
                throw CLIError.translationFailed("Model returned an empty response.")
            }
            return trimmed
        } catch {
            lastError = error
            let delay = config.retryDelay * Double(attempt)
            if attempt < maxAttempts {
                print("Request failed, retrying in \(delay)s (attempt \(attempt))...")
                Thread.sleep(forTimeInterval: delay)
            }
        }
    }
    throw lastError ?? CLIError.translationFailed("Unknown error")
}

// MARK: - Utilities

private struct ProcessResult {
    let output: String
    let error: String
    let status: Int32
}

private func runProcess(executable: String, arguments: [String]) throws -> ProcessResult {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments
    let stdout = Pipe()
    let stderr = Pipe()
    process.standardOutput = stdout
    process.standardError = stderr
    try process.run()
    process.waitUntilExit()
    let outData = stdout.fileHandleForReading.readDataToEndOfFile()
    let errData = stderr.fileHandleForReading.readDataToEndOfFile()
    return ProcessResult(
        output: String(data: outData, encoding: .utf8) ?? "",
        error: String(data: errData, encoding: .utf8) ?? "",
        status: process.terminationStatus
    )
}

private func humanReadableSize(bytes: Int64) -> String {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useGB, .useMB]
    formatter.countStyle = .binary
    return formatter.string(fromByteCount: bytes)
}

private func renderProgress(current: Int, total: Int) {
    guard total > 0 else { return }
    let barWidth = 30
    let progress = min(max(Double(current) / Double(total), 0), 1)
    let filled = Int(progress * Double(barWidth))
    let bar = String(repeating: "#", count: filled) + String(repeating: "-", count: barWidth - filled)
    let percentage = Int(progress * 100)
    let message = String(format: "Translating [%@] %3d%% (%d/%d)", bar, percentage, current, total)
    print("\r\(message)", terminator: "")
    fflush(stdout)
    if current >= total {
        print()
    }
}

private final class SyncResponseBox: @unchecked Sendable {
    var data: Data?
    var response: URLResponse?
    var error: Error?
}

private extension URLSession {
    func syncRequest(for request: URLRequest) throws -> (Data, URLResponse) {
        let semaphore = DispatchSemaphore(value: 0)
        let box = SyncResponseBox()

        let task = dataTask(with: request) { data, urlResponse, error in
            box.data = data
            box.response = urlResponse
            box.error = error
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()

        if let error = box.error {
            throw error
        }
        guard let urlResponse = box.response else {
            throw CLIError.translationFailed("No response received from the server.")
        }
        return (box.data ?? Data(), urlResponse)
    }
}

private final class TerminalMenu {
    private let items: [ModelDisplayInfo]
    private var selectedIndex = 0

    init(items: [ModelDisplayInfo]) {
        self.items = items
    }

    func interactiveSelection() -> String {
        guard !items.isEmpty else { fatalError("No model to select from") }
        var originalTermios = termios()
        let fd = STDIN_FILENO
        guard tcgetattr(fd, &originalTermios) == 0 else {
            print("Terminal does not support interactive selection, defaulting to \(items[0].name)")
            return items[0].name
        }
        var raw = originalTermios
        raw.c_lflag &= ~tcflag_t(ICANON | ECHO)
        withUnsafeMutablePointer(to: &raw.c_cc) {
            $0.withMemoryRebound(to: cc_t.self, capacity: Int(NCCS)) {
                $0[Int(VMIN)] = 1
                $0[Int(VTIME)] = 0
            }
        }
        guard tcsetattr(fd, TCSAFLUSH, &raw) == 0 else {
            print("Unable to switch terminal to raw mode, defaulting to \(items[0].name)")
            return items[0].name
        }
        print("\u{1B}[?25l", terminator: "") // hide cursor
        defer {
            tcsetattr(fd, TCSAFLUSH, &originalTermios)
            print("\u{1B}[?25h", terminator: "")
        }

        while true {
            renderMenu()
            if let key = readKey(fd: fd) {
                switch key {
                case .up:
                    selectedIndex = (selectedIndex - 1 + items.count) % items.count
                case .down:
                    selectedIndex = (selectedIndex + 1) % items.count
                case .enter:
                    clearScreen()
                    return items[selectedIndex].name
                }
            }
        }
    }

    private func renderMenu() {
        clearScreen()
        print("Select an Ollama model (use ↑/↓, press Enter):\n")
        for (idx, item) in items.enumerated() {
            let prefix = idx == selectedIndex ? "➤" : " "
            let line = "\(prefix) \(item.name) (\(item.description))"
            if idx == selectedIndex {
                print("\u{1B}[7m\(line)\u{1B}[0m")
            } else {
                print(line)
            }
        }
    }

    private func clearScreen() {
        print("\u{1B}[2J\u{1B}[H", terminator: "")
        fflush(stdout)
    }

    private enum Key {
        case up
        case down
        case enter
    }

    private func readKey(fd: Int32) -> Key? {
        guard let first = readByte(fd: fd) else { return nil }
        switch first {
        case 0x1B:
            guard let second = readByte(fd: fd), second == 0x5B, let third = readByte(fd: fd) else {
                return nil
            }
            switch third {
            case 0x41:
                return .up
            case 0x42:
                return .down
            default:
                return nil
            }
        case 0x0D, 0x0A:
            return .enter
        default:
            return nil
        }
    }

    private func readByte(fd: Int32) -> UInt8? {
        var buffer: UInt8 = 0
        let bytesRead = Darwin.read(fd, &buffer, 1)
        return bytesRead == 1 ? buffer : nil
    }
}

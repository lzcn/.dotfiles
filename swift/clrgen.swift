import Foundation
import AppKit

// MARK: - Models
struct ColorEntry: Codable {
    let hex: String
    let name: String?
}

struct Palette: Codable {
    let name: String
    let colors: [ColorEntry]
}

// MARK: - Color Conversion
enum ColorError: Error, LocalizedError {
    case invalidHexFormat(String)
    case invalidHexLength(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidHexFormat(let hex):
            return "Invalid hex color format: '\(hex)'. Expected format: #RRGGBB or RRGGBB"
        case .invalidHexLength(let hex):
            return "Invalid hex color length: '\(hex)'. Expected 6 characters (RRGGBB)"
        }
    }
}

func colorFromHex(_ hex: String) throws -> NSColor {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    // Validate hex length
    guard hexSanitized.count == 6 else {
        throw ColorError.invalidHexLength(hex)
    }
    
    // Validate hex characters
    guard hexSanitized.allSatisfy({ $0.isHexDigit }) else {
        throw ColorError.invalidHexFormat(hex)
    }
    
    var rgb: UInt64 = 0
    Scanner(string: hexSanitized).scanHexInt64(&rgb)

    let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgb & 0x0000FF) / 255.0

    return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
}

// MARK: - Helper Functions
func validateInputFile(_ path: String) throws {
    let url = URL(fileURLWithPath: path)
    
    guard FileManager.default.fileExists(atPath: path) else {
        throw NSError(domain: "FileError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Input file does not exist: \(path)"])
    }
    
    guard url.pathExtension.lowercased() == "json" else {
        throw NSError(domain: "FileError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Input file must be a JSON file"])
    }
}

func generateOutputPath(from inputPath: String, customOutput: String?) throws -> String {
    if let customOutput = customOutput {
        guard customOutput.hasSuffix(".clr") else {
            throw NSError(domain: "FileError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Output file must have .clr extension"])
        }
        return customOutput
    } else {
        let inputURL = URL(fileURLWithPath: inputPath)
        let baseName = inputURL.deletingPathExtension().lastPathComponent
        return FileManager.default.currentDirectoryPath + "/\(baseName).clr"
    }
}

// MARK: - Main
guard CommandLine.arguments.count >= 2 else {
    print("Usage: swift clrgen.swift <palette.json> [output.clr]")
    print("")
    print("Converts a JSON color palette to a macOS .clr file")
    print("")
    print("Arguments:")
    print("  palette.json  - Input JSON file containing color palette")
    print("  output.clr    - Optional output .clr file (defaults to <palette_name>.clr)")
    print("")
    print("Example JSON format:")
    print("""
{
  "name": "My Color Palette",
  "colors": [
    {
      "hex": "#FF0000",
      "name": "Red"
    },
    {
      "hex": "#00FF00",
      "name": "Green"
    },
    {
      "hex": "#0000FF",
      "name": "Blue"
    },
    {
      "hex": "#FFFF00"
    }
  ]
}
""")
    print("")
    print("Note: Color names are optional. If not provided, colors will be named 'Color1', 'Color2', etc.")
    exit(1)
}

let jsonPath = CommandLine.arguments[1]
let customOutput = CommandLine.arguments.count >= 3 ? CommandLine.arguments[2] : nil

do {
    // Validate input file
    try validateInputFile(jsonPath)
    
    // Generate output path
    let outputPath = try generateOutputPath(from: jsonPath, customOutput: customOutput)
    
    // Load and parse JSON
    let jsonURL = URL(fileURLWithPath: jsonPath)
    let data = try Data(contentsOf: jsonURL)
    let palette = try JSONDecoder().decode(Palette.self, from: data)
    
    // Validate palette has colors
    guard !palette.colors.isEmpty else {
        throw NSError(domain: "PaletteError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Palette must contain at least one color"])
    }
    
    // Create color list
    let colorList = NSColorList(name: palette.name)
    
    // Process colors with validation
    for (index, colorEntry) in palette.colors.enumerated() {
        do {
            let color = try colorFromHex(colorEntry.hex)
            let name = colorEntry.name ?? "Color\(index + 1)"
            colorList.setColor(color, forKey: name)
        } catch {
            print("⚠️  Warning: Skipping invalid color at index \(index): \(error.localizedDescription)")
            continue
        }
    }
    
    // Check if any colors were successfully added
    guard colorList.allKeys.count > 0 else {
        throw NSError(domain: "PaletteError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No valid colors found in palette"])
    }
    
    // Save the color list
    try colorList.write(to: URL(fileURLWithPath: outputPath))
    print("✅ Successfully saved color palette '\(palette.name)' with \(colorList.allKeys.count) colors to: \(outputPath)")
    
} catch {
    print("❌ Error: \(error.localizedDescription)")
    exit(1)
}

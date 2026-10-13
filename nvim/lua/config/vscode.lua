-- Reuse editing plugins; let VS Code own editors, language tools, and panels.
local vscode = require("vscode")
local shortcuts = {}
local function action(mode, lhs, command, desc)
  vim.keymap.set(mode, lhs, function()
    vscode.action(command)
  end, { desc = desc })
  if mode == "n" or (type(mode) == "table" and vim.tbl_contains(mode, "n")) then
    local item = shortcuts[command] or { label = desc, command = command, keys = {} }
    local display_key = lhs:gsub("<leader>", "Space "):gsub("<space>", "Space")
    table.insert(item.keys, display_key)
    shortcuts[command] = item
  end
end

if vim.g.vscode_clipboard then
  vim.g.clipboard = vim.g.vscode_clipboard
end

-- VS Code owns the display geometry, including soft wraps.
for key, direction in pairs({ j = "down", k = "up", ["<Down>"] = "down", ["<Up>"] = "up" }) do
  vim.keymap.set({ "n", "x" }, key, function()
    local mode = vim.fn.mode()
    if vim.v.count > 0 or mode == "V" or mode == "\22" then
      return key
    end
    vscode.action("cursorMove", {
      args = { to = direction, by = "wrappedLine", value = 1, select = mode == "v" },
    })
    return "<Ignore>"
  end, { expr = true, desc = "Move by Display Line" })
end

-- Share VS Code's undo history with editor commands and AI extension edits.
for key, command in pairs({ u = "undo", ["<C-r>"] = "redo" }) do
  vim.keymap.set("n", key, function()
    for _ = 1, vim.v.count1 do
      vscode.call(command)
    end
  end, { desc = command == "undo" and "Undo" or "Redo" })
end

for _, lhs in ipairs({ "<leader>ff", "<leader>fF" }) do
  action("n", lhs, "workbench.action.quickOpen", "Find Files")
end
action("n", "<leader>fr", "workbench.action.quickOpen", "Recent Files")
action("n", "<leader>,", "workbench.action.showAllEditors", "Switch Buffer")
action("n", "<leader>fb", "workbench.action.showAllEditors", "Switch Buffer")
action("n", "<leader>fn", "workbench.action.files.newUntitledFile", "New File")
action("n", "<leader>e", "workbench.view.explorer", "Open Explorer")
for _, lhs in ipairs({ "<leader>E", "<leader>fE" }) do
  action("n", lhs, "workbench.files.action.showActiveFileInExplorer", "Reveal Current File")
end
action("n", "<leader>ue", "workbench.action.toggleSidebarVisibility", "Toggle Sidebar")
action("n", "<leader>sg", "workbench.action.findInFiles", "Search Project")
action("n", "<leader>sr", "workbench.action.replaceInFiles", "Replace in Project")
vim.keymap.set({ "n", "x" }, "<leader>sw", function()
  vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
end, { desc = "Search Word" })
action("n", "<leader>sS", "workbench.action.showAllSymbols", "Workspace Symbols")
action("n", "<leader>sk", "workbench.action.openGlobalKeybindings", "Keyboard Shortcuts")

action("n", "[b", "workbench.action.previousEditor", "Previous Buffer")
action("n", "]b", "workbench.action.nextEditor", "Next Buffer")
action("n", "<leader>bb", "workbench.action.openPreviousRecentlyUsedEditor", "Alternate Buffer")
action("n", "<leader>`", "workbench.action.openPreviousRecentlyUsedEditor", "Alternate Buffer")
action("n", "<leader>bd", "workbench.action.closeActiveEditor", "Close Buffer")
action("n", "<leader>bD", "workbench.action.closeActiveEditor", "Close Buffer")
action("n", "<leader>bo", "workbench.action.closeOtherEditors", "Close Other Buffers")
action("n", "<leader>bp", "workbench.action.pinEditor", "Pin Buffer")
action("n", "<leader>br", "workbench.action.closeEditorsToTheRight", "Close Buffers to the Right")
action("n", "<leader>-", "workbench.action.splitEditorDown", "Split Below")
action("n", "<leader>|", "workbench.action.splitEditorRight", "Split Right")
action("n", "<leader>wd", "workbench.action.closeGroup", "Close Window")
action("n", "<leader>wm", "workbench.action.toggleMaximizeEditorGroup", "Maximize Window")
for key, direction in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
  action("n", "<C-" .. key .. ">", "workbench.action.navigate" .. direction, "Focus " .. direction)
end
for key, command in pairs({
  Up = "workbench.action.increaseViewHeight",
  Down = "workbench.action.decreaseViewHeight",
  Left = "workbench.action.decreaseViewWidth",
  Right = "workbench.action.increaseViewWidth",
}) do
  action("n", "<C-" .. key .. ">", command, "Resize View " .. key)
end
action("n", "<C-_>", "workbench.action.terminal.toggleTerminal", "Toggle Terminal")

action("n", "gD", "editor.action.revealDeclaration", "Declaration")
action("n", "gr", "editor.action.goToReferences", "References")
action("n", "gI", "editor.action.goToImplementation", "Implementation")
action("n", "gy", "editor.action.goToTypeDefinition", "Type Definition")
action("n", "gK", "editor.action.triggerParameterHints", "Signature Help")
action({ "n", "x" }, "<leader>ca", "editor.action.quickFix", "Code Action")
action("n", "<leader>cr", "editor.action.rename", "Rename Symbol")
action("n", "<leader>co", "editor.action.organizeImports", "Organize Imports")
for _, lhs in ipairs({ "<leader>cf", "<A-F>" }) do
  action("n", lhs, "editor.action.formatDocument", "Format Document")
  action("x", lhs, "editor.action.formatSelection", "Format Selection")
end
action("n", "<leader>cd", "editor.action.showHover", "Line Diagnostics")
action("n", "]d", "editor.action.marker.next", "Next Diagnostic")
action("n", "[d", "editor.action.marker.prev", "Previous Diagnostic")
action("n", "<leader>xx", "workbench.actions.view.problems", "Problems")
action("n", "<leader>gg", "workbench.view.scm", "Source Control")
action("n", "<leader>gs", "workbench.view.scm", "Git Status")
action("n", "]h", "workbench.action.editor.nextChange", "Next Git Change")
action("n", "[h", "workbench.action.editor.previousChange", "Previous Git Change")
action("n", "<leader>ghp", "editor.action.dirtydiff.next", "Preview Git Change")
action("n", "<leader>uw", "editor.action.toggleWordWrap", "Toggle Wrap")
action("n", "<leader>uz", "workbench.action.toggleZenMode", "Zen Mode")
action("n", "<leader>uZ", "workbench.action.toggleMaximizeEditorGroup", "Maximize Window")
action("n", "<leader>qq", "workbench.action.closeWindow", "Quit Window")
action({ "n", "x", "i" }, "<A-j>", "editor.action.moveLinesDownAction", "Move Lines Down")
action({ "n", "x", "i" }, "<A-k>", "editor.action.moveLinesUpAction", "Move Lines Up")

-- Discover the adapted commands without needing another VS Code extension.
vim.keymap.set("n", "<leader>?", function()
  local items = {}
  for _, item in pairs(shortcuts) do
    table.insert(items, { label = item.label, description = table.concat(item.keys, ", "), command = item.command })
  end
  vscode.eval_async([[
    const items = args.sort((a, b) => a.label.localeCompare(b.label));
    const picked = await vscode.window.showQuickPick(items, {
      placeHolder: "LazyVim actions — search by name or shortcut",
      matchOnDescription: true
    });
    if (picked) await vscode.commands.executeCommand(picked.command);
  ]], { args = items })
end, { desc = "Show LazyVim Actions" })

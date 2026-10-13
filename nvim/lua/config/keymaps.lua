-- Add any additional keymaps here
local map = vim.keymap.set

-- Format file using vscode keymap
if not vim.g.vscode then
  map("n", "<A-F>", function() LazyVim.format({ force = true }) end, { desc = "Format" })
end

-- Join lines without moving the cursor
map("n", "J", "mzJ`z", { desc = "Join Lines" })

-- Paste over a visual selection without losing the yanked text
map("x", "p", '"_dP', { desc = "Paste Without Yanking" })

-- Navigate windows from terminal mode, same keys as everywhere else
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to Left Window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to Right Window" })

if vim.g.vscode then
  require("config.vscode")
end


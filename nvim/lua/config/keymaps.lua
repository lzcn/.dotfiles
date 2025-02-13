-- Add any additional keymaps here
local keymapSet = vim.keymap.set

-- Define keymap options
local keymapOptions = {
  normalMode = { noremap = true, silent = true },
  insertMode = { noremap = true, silent = true },
  visualMode = { noremap = true, silent = true },
  selectMode = { noremap = true, silent = true },
  terminalMode = { expr = true },
}

-- Normal mode keymaps
-- Select all
keymapSet("n", "<C-a>", "ggVG", keymapOptions.normalMode)

-- Open file
-- keymapSet("n", "<A-o>", "<cmd>lua require('telescope.builtin').find_files()<cr>", keymapOptions.normalMode)
-- Save file
-- keymapSet("n", "<D-s>", "<cmd>update<cr>", keymapOptions.normalMode)

-- Format file using vscode keymap
keymapSet("n", "<A-F>", "<cmd>LazyFormat<cr>", keymapOptions.normalMode)

-- Insert mode keymaps
-- Navigation
local insertNavKeys = { h = "<left>", j = "<down>", k = "<up>", l = "<right>", a = "<esc>^i", e = "<esc>$a" }
for key, action in pairs(insertNavKeys) do
  keymapSet("i", "<C-" .. key .. ">", action, keymapOptions.insertMode)
end

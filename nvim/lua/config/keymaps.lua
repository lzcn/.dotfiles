-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymapSet = vim.keymap.set
local keymapDel = vim.keymap.del
local keymapOptions = {
  normalMode = {
    noremap = true,
    silent = true,
  },
  insertMode = {
    noremap = true,
    silent = true,
  },
  visualMode = {
    noremap = true,
    silent = true,
  },
  selectMode = {
    noremap = true,
    silent = true,
  },
  terminalMode = {
    expr = true,
  },
}

-- Delete default window keymaps
-- keymapDel("n", "<leader>ww")
-- keymapDel("n", "<leader>wd")
-- keymapDel("n", "<leader>w-")
-- keymapDel("n", "<leader>w|")

-- Normal mode keymaps
-- Select all
keymapSet("n", "<C-a>", "ggVG", keymapOptions.normalMode)

-- Floating terminal
local util = require("lazyvim.util")
keymapSet("n", "<A-i>", function()
  util.terminal(nil, { cwd = util.root() })
end, keymapOptions.normalMode)
keymapSet("t", "<A-i>", "<cmd>close<cr>")

-- Open file
keymapSet("n", "<A-o>", "<cmd>lua require('telescope.builtin').find_files()<cr>", keymapOptions.normalMode)

-- Save file
keymapSet("n", "<D-s>", "<cmd>update<cr>", keymapOptions.normalMode)

-- Format file using vscode keymap
keymapSet("n", "<A-F>", "<cmd>LazyFormat<cr>", keymapOptions.normalMode)

-- Insert mode keymaps
-- Navigation
keymapSet("i", "<C-h>", "<left>", keymapOptions.insertMode)
keymapSet("i", "<C-j>", "<down>", keymapOptions.insertMode)
keymapSet("i", "<C-k>", "<up>", keymapOptions.insertMode)
keymapSet("i", "<C-l>", "<right>", keymapOptions.insertMode)
keymapSet("i", "<C-a>", "<esc>^i", keymapOptions.insertMode)
keymapSet("i", "<C-e>", "<esc>$a", keymapOptions.insertMode)

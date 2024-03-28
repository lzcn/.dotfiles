-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local set = vim.keymap.set
local del = vim.keymap.del
local opts = {
  n = {
    noremap = true,
    silent = true,
  },
  i = {
    noremap = true,
    silent = true,
  },
  v = {
    noremap = true,
    silent = true,
  },
  x = {
    noremap = true,
    silent = true,
  },
  t = {
    expr = true,
  },
}
-- delete default window keymaps
del("n", "<leader>ww")
del("n", "<leader>wd")
del("n", "<leader>w-")
del("n", "<leader>w|")

-- select all
set("n", "<C-a>", "ggVG", opts.n)

-- floating terminal
local util = require "lazyvim.util"
set("n", "<A-i>", function()
  util.terminal(nil, { cwd = util.root() })
end, opts.n)
set("t", "<A-i>", "<cmd>close<cr>")

-- open file
set("n", "<A-o>", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts.n)

-- format file using vscode keymap
set("n", "<A-F>", "<cmd>LazyFormat<cr>", opts.n)

-- insert mode --
-- navigation
set("i", "<C-h>", "<left>", opts.i)
set("i", "<C-j>", "<down>", opts.i)
set("i", "<C-k>", "<up>", opts.i)
set("i", "<C-l>", "<right>", opts.i)
set("i", "<C-a>", "<esc>^i", opts.i)
set("i", "<C-e>", "<esc>$a", opts.i)

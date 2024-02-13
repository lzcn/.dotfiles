-- vim options
local opt = vim.opt
opt.relativenumber = true -- relative line numbers
opt.termguicolors = true -- 24-bit RGB colors
opt.wrap = false -- disable wrap

-- autocmds
local autocmd = vim.api.nvim_create_autocmd
-- auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- disable auto comment on new line
autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
  pattern = "*",
  command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

-- let treesitter use bash highlight for zsh files as well
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

-- disable auto comment
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufRead", "BufNewFile" }, {
  pattern = "*",
  command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

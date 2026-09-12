-- Add custom autocmds here

-- LazyVim turns on spellcheck for markdown/gitcommit by default; it flags too many
-- false positives (code identifiers, mixed Chinese/English) to be useful here.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

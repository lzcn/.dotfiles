-- Add custom autocmds here

-- Wrap prose; keep code at LazyVim's default of no wrapping.
local prose = { "text", "markdown", "markdown.mdx", "tex", "plaintex", "rst", "asciidoc", "gitcommit", "mail" }
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.wrap = vim.tbl_contains(prose, vim.bo.filetype)
  end,
})

-- LazyVim turns on spellcheck for markdown/gitcommit by default; it flags too many
-- false positives (code identifiers, mixed Chinese/English) to be useful here.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

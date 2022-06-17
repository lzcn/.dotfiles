local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
  { command = "isort", filetypes = { "python" } },
  { command = "black", filetypes = { "python" } },
  { command = "stylua", filetypes = { "lua" } },
  { command = "shfmt", extra_args = { "-i", "2", "-ci" } },
  { command = "prettier", filetypes = { "markdown", "css", "typescript", "javascript", "yaml" } },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
  { command = "eslint", filetypes = { "typescript", "javascript" } },
  { command = "flake8", filetypes = { "python" } },
  { command = "shellcheck", extra_args = { "--severity", "warning" } },
  { command = "codespell" },
})

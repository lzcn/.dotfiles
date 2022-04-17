local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "isort", filetypes = { "python" } },
	{ command = "black", filetypes = { "python" } },
	{ command = "stylua", filetypes = { "lua" } },
	{ command = "prettier", filetypes = { "typescript", "javascript" } },
})

local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "eslint", filetypes = { "typescript", "javascript" } },
	{ command = "flake8", filetypes = { "python" } },
	{ command = "shellcheck", extra_args = { "--severity", "warning" } },
	{ command = "codespell" },
})

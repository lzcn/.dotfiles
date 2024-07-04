return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        settings = {
          pyright = { disableOrganizeImports = true },
          python = { analysis = { typeCheckingMode = "basic", ignore = { "*" } } },
        },
      },
      ruff_lsp = { settings = { lint = { enable = false } } },
    },
  },
}

return {
  "neovim/nvim-lspconfig",
  -- opts will be merged with the parent spec
  opts = {
    servers = {
      pyright = {
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              typeCheckingMode = "basic",
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
      },
      ruff_lsp = {
        settings = {
          lint = {
            enable = false,
          },
        },
      },
    },
  },
}

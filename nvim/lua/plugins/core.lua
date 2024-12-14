return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        black = {
          prepend_args = { "--line-length", "120" },
        },
      },
      formatters_by_ft = {
        ["python"] = { "isort", "black" },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
  },
  {
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
  },
}

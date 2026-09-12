return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha",
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = {
          -- Don't preselect the first item on menu open;
          -- the first <Tab> press selects the first item.
          selection = { preselect = false, auto_insert = false },
        },
      },
      keymap = {
        -- Enter accepts: completion menu > Copilot ghost text (ai.copilot-native) > plain newline
        ["<CR>"] = {
          "accept",
          function() return LazyVim.cmp.actions.ai_accept and LazyVim.cmp.actions.ai_accept() end,
          "fallback",
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        beautysh = {
          prepend_args = { "-i", "2" },
        },
        ruff_format = {
          prepend_args = { "--line-length", "120" },
        },
      },
      formatters_by_ft = {
        ["python"] = { "ruff_organize_imports", "ruff_format" },
        ["sh"] = { "shfmt" },
        ["zsh"] = { "beautysh" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- No markdown linting: hide markdownlint (MD0xx) diagnostics entirely
        markdown = false,
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
            python = { analysis = { typeCheckingMode = "off" } },
          },
        },
        ruff = { settings = { lint = { enable = false } } },
      },
    },
  },
}

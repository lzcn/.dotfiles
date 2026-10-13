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
      no_italic = true,
      custom_highlights = function(colors)
        return {
          Cursor = { fg = colors.base, bg = colors.blue },
          WinSeparator = { fg = colors.surface1 },
          Visual = { bg = colors.surface0 },
          PmenuSel = { fg = colors.blue, bg = colors.surface0, bold = true },
          BlinkCmpMenuSelection = { link = "PmenuSel" },
        }
      end,
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        numbers = "ordinal",
        separator_style = "thin",
        show_close_icon = false,
        show_buffer_close_icons = false,
      },
      highlights = {
        fill = { bg = "#1e1e2e" },
        background = { fg = "#a6adc8", bg = "#1e1e2e" },
        buffer_selected = { fg = "#89b4fa", bg = "#313244", bold = true, italic = false },
        numbers_selected = { fg = "#89b4fa", bg = "#313244", bold = true },
        separator = { fg = "#45475a", bg = "#1e1e2e" },
        separator_selected = { fg = "#45475a", bg = "#313244" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { component_separators = "·", section_separators = "" },
      sections = { lualine_b = { { "branch", color = { fg = "#cba6f7" } } } },
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

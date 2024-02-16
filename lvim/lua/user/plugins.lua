lvim.plugins = {
  -- colorscheme
  {
    "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup {
        lualine_bg_color = "#282A36",
        italic_comment = true,
      }
    end,
  },
  {
    "navarasu/onedark.nvim",
    config = function()
      require("onedark").setup {
        style = "dark",
      }
    end,
  },

  -- rainbow delimiters
  { "HiPhish/rainbow-delimiters.nvim" },
  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = { "yaml", "lua", "css", "javascript" },
      user_default_options = {
        names = false,
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        AARRGGBB = true,
        mode = "virtualtext",
      },
    },
  },
  -- log highlight
  {
    "fei6409/log-highlight.nvim",
    ft = "log",
    config = function()
      require("log-highlight").setup {}
    end,
    enabled = lvim.user.log.active,
  },
  -- csv highlight
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
    enabled = lvim.user.csv.active,
  },
  -- line warp
  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup()
    end,
    enabled = lvim.user.wrapping.active,
    lazy = true,
  },
  -- git --
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
    enabled = lvim.user.git.diffview,
  },

  -- input-method --
  {
    "h-hg/fcitx.nvim",
    enabled = lvim.user.fcitx.active and lvim.user.macos,
  },

  -- LSP --
  -- previewing definition
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup()
    end,
    enabled = false,
  },
  -- signature hint when typing
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
    enabled = lvim.user.lsp.signature,
  },

  -- Diagnostics --
  {
    "folke/trouble.nvim",
    cmd = "TroubleToogle",
    enabled = lvim.user.trouble.active,
  },
  -- better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    config = function()
      require("user.bqf").config()
    end,
    event = "BufRead",
    ft = "qf",
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require "user.conform"
    end,
    lazy = true,
  },
  -- Navigation --
  -- enhanced matchup
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -- navigate within tmux panes
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup()
    end,
  },
  -- peek line
  {
    "nacro90/numb.nvim",
    config = function()
      require("numb").setup()
    end,
    enabled = lvim.user.navigation.numb,
  },
  -- fast navigation
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
    enabled = lvim.user.navigation.lightspeed,
  },
  -- ranger
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
    enabled = lvim.user.navigation.rnvimr,
  },
  -- open url
  {
    "felipec/vim-sanegx",
    event = "BufRead",
    enabled = false,
  },

  -- Python --
  -- pydocstring
  {
    "heavenshell/vim-pydocstring",
    build = "make install",
    ft = { "python" },
    config = function()
      vim.g.pydocstring_formatter = "google"
    end,
    enabled = false,
  },
  -- jupyter-notebook
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    ft = { "python" },
    enabled = lvim.user.magma.active,
  },
  -- sphinx support
  {
    "stsewd/sphinx.nvim",
    build = ":UpdateRemotePlugins",
    ft = { "rst" },
  },
  -- switch virtualenv
  { "AckslD/swenv.nvim" },
  -- default dap configuration for python
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      require("dap-python").setup "python"
    end,
    enabled = lvim.builtin.dap.active,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
    enabled = lvim.builtin.dap.active,
  },
  -- LaTeX --
  {
    "lervag/vimtex",
    ft = { "tex" },
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_quickfix_mode = 0
    end,
    enabled = lvim.user.tex.active and lvim.user.macos,
  },
  {
    "kdheepak/cmp-latex-symbols",
    denpencies = "hrsh7th/nvim-cmp",
    ft = "tex",
    enabled = lvim.user.tex.active and lvim.user.macos,
  },

  -- Markdown --
  -- preview with glow
  {
    "npxbr/glow.nvim",
    ft = { "markdown" },
    enabled = lvim.user.markdown.glow,
  },
  -- preview on browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 1
    end,
    enabled = lvim.user.markdown.preview,
  },

  -- Utility --

  -- copilot and copolot-cmp
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {}
    end,
    enabled = lvim.user.copilot.active,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    end,
    enabled = lvim.user.copilot.cmp,
  },
  -- automatic session saver
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  -- open at last edited position
  {
    "vladdoster/remember.nvim",
    config = function()
      require("remember").setup {}
    end,
    event = "BufWinEnter",
    enabled = lvim.user.lastplace.active,
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    lazy = true,
  },
  -- delete, change and add surroundings
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  -- show registers
  {
    "tversteeg/registers.nvim",
    name = "registers",
    keys = {
      { '"', mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    cmd = "Registers",
    config = function()
      require("registers").setup { show_empty = false }
    end,
    enabled = false,
  },
}

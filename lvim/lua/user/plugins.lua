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
  -- rainbow parentheses
  {
    "mrjones2014/nvim-ts-rainbow",
  },
  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup {
        filetypes = { "yaml", "lua", "css", "javascript" },
        user_default_options = {
          names = false, -- "Name" codes like Blue or blue
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          mode = "virtualtext",
        },
      }
    end,
  },
  -- #TODO: replace with nvim plugin
  {
    "mtdl9/vim-log-highlighting",
    ft = { "log" },
    enabled = lvim.user.log.active,
  },
  -- #TODO: replace with nvim plugin
  {
    "chrisbra/csv.vim",
    ft = { "csv" },
    enabled = lvim.user.csv.active,
  },
  -- line warp
  {
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup()
    end,
    enabled = lvim.user.wrapping.active,
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
    config = function()
      require("lsp_signature").on_attach()
    end,
    event = "BufRead",
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
  },
  -- jupyter-notebook
  {
    "dccsillag/magma-nvim",
    build = ":UpdateRemotePlugins",
    ft = { "python" },
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
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          suggestion = {
            enabled = not lvim.user.copilot.cmp,
            auto_trigger = true,
            debounce = 75,
            keymap = {
              accept = "<C-f>",
              next = "<M-]>",
              prev = "<M-[>",
              dismiss = "<C-]>",
            },
          },
          panel = {
            enabled = not lvim.user.copilot.cmp,
            auto_refresh = false,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<M-CR>",
            },
            layout = {
              position = "right",
              ratio = 0.4,
            },
          },
          filetypes = {
            yaml = true,
            mardown = true,
            gitcommit = false,
          },
        }
        require("copilot_cmp").setup()
      end, 100)
    end,
    enabled = lvim.user.copilot.active,
  },
  -- automatic session saver
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup()
    end,
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
    event = "BufRead",
    config = function()
      require("todo-comments").setup {
        signs = false, -- icons in the sign column
      }
    end,
  },
  -- delete, change and add surroundings
  {
    "tpope/vim-surround",
    keys = { "c", "d", "y" },
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
  },
}

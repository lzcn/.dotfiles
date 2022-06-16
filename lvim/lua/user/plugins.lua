lvim.plugins = {
  -- Aesthetics --
  -- colorscheme
  -- { "folke/tokyonight.nvim" },
  -- { "joshdick/onedark.vim" },
  { "Mofiqul/dracula.nvim" },
  -- rainbow parentheses
  { "p00f/nvim-ts-rainbow" },
  -- display color
  { "norcalli/nvim-colorizer.lua" },

  -- LSP --
  -- diagnostics highlight for non-LSP colorscheme
  { "folke/lsp-colors.nvim" },
  -- previewing definition
  {
    "rmagatti/goto-preview",
    config = function()
      require("goto-preview").setup({})
    end,
  },
  -- hitn signature when type
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      require("lsp_signature").setup()
    end,
    event = { "BufRead", "BufNew" },
  },
  {
    "nathom/filetype.nvim",
    config = function()
      require("user.filetype").config()
    end,
  },
  -- Diagnostics --
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup({
        auto_open = true,
        auto_close = true,
        padding = false,
        height = 10,
        use_diagnostic_signs = true,
      })
    end,
    cmd = "Trouble",
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
    event = "BufReadPost",
    config = function()
      vim.g.matchup_enabled = 1
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_matchparen_deferred = 1
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
    disable = not lvim.user.navigation.numb,
  },
  -- fast navigation
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
    disable = not lvim.user.navigation.lightspeed,
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
    disable = not lvim.user.navigation.rnvimr,
  },

  -- Python --
  -- pydocstring
  {
    "heavenshell/vim-pydocstring",
    run = "make install",
    ft = { "python" },
    config = function()
      vim.g.pydocstring_formatter = "google"
    end,
  },
  -- jupyter-notebook
  { "dccsillag/magma-nvim", run = ":UpdateRemotePlugins", ft = { "python" } },
  -- sphinx support
  { "stsewd/sphinx.nvim", run = ":UpdateRemotePlugins", ft = { "rst" } },

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
  },
  {
    "kdheepak/cmp-latex-symbols",
    requires = "hrsh7th/nvim-cmp",
    ft = "tex",
  },

  -- Markdown --
  -- preview with glow
  { "npxbr/glow.nvim", ft = { "markdown" } },
  -- preview on browser
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 1
    end,
  },

  -- Utility --
  -- copilot
  {
    "github/copilot.vim",
    config = function()
      require("user.copilot").config()
    end,
    disable = not lvim.user.copilot.active,
  },
  {
    "abecodes/tabout.nvim",
    wants = { "nvim-treesitter" },
    after = { "nvim-cmp" },
    config = function()
      require("user.tabout").config()
    end,
    disable = not lvim.user.copilot.active,
  },

  -- automatic session saver
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  },

  -- open at last edited position
  {
    "vladdoster/remember.nvim",
    config = function()
      require("remember").setup({})
    end,
    event = "BufWinEnter",
    disable = not lvim.user.lastplace.active,
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    event = "BufRead",
  },

  -- delete, change and add surroundings
  {
    "tpope/vim-surround",
    keys = { "c", "d", "y" },
  },

  -- highlight the word under the cursor
  {
    "xiyaowong/nvim-cursorword",
    event = { "BufEnter", "BufNewFile" },
  },
}

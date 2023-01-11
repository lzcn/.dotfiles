lvim.plugins = {
  -- colorscheme
  {
    "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup({
        lualine_bg_color = "#282A36",
        italic_comment = true,
      })
    end,
  },
  -- rainbow parentheses
  { "p00f/nvim-ts-rainbow" },
  -- display color
  { "norcalli/nvim-colorizer.lua" },
  -- hihglight logfile
  { "mtdl9/vim-log-highlighting", ft = { "text", "log" }, enabled = lvim.user.log.active },
  -- lighlight csv file
  { "chrisbra/csv.vim", ft = { "csv" }, enabled = lvim.user.csv.active },
  -- line warp
  {
    "andrewferrier/vim-wrapping-softhard",
    config = function()
      require("wrapping").setup()
    end,
  },
  -- git --
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },

  -- input-method --
  { "h-hg/fcitx.nvim", enabled = lvim.user.fcitx.active and lvim.user.macos },

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
    enabled = lvim.user.lsp_signature.active,
  },
  {
    "nathom/filetype.nvim",
    config = function()
      require("user.filetype").config()
    end,
  },
  -- Diagnostics --
  { "folke/trouble.nvim", cmd = "TroubleToogle" },
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
  { "dccsillag/magma-nvim", build = ":UpdateRemotePlugins", ft = { "python" } },
  -- sphinx support
  { "stsewd/sphinx.nvim", build = ":UpdateRemotePlugins", ft = { "rst" } },

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
    enabled = lvim.user.tex.active,
  },
  {
    "kdheepak/cmp-latex-symbols",
    denpencies = "hrsh7th/nvim-cmp",
    ft = "tex",
    enabled = lvim.user.tex.active,
  },

  -- Markdown --
  -- preview with glow
  { "npxbr/glow.nvim", ft = { "markdown" }, enabled = lvim.user.markdown.glow },
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

  -- copilot
  {
    "github/copilot.vim",
    config = function()
      require("user.copilot").config()
    end,
    enabled = lvim.user.copilot.active and not lvim.user.copilot.cmp,
  },
  {
    "abecodes/tabout.nvim",
    dependencies = { "nvim-treesitter", "nvim-cmp" },
    config = function()
      require("user.tabout").config()
    end,
    enabled = lvim.user.copilot.active and not lvim.user.copilot.cmp,
  },
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter" },
    dependencies = { "lualine.nvim" },
    config = function()
      vim.schedule(function()
        require("user.copilot").config()
      end)
    end,
    enabled = lvim.user.copilot.active and lvim.user.copilot.cmp,
  },
  {
    "zbirenbaum/copilot-cmp",
    denpencies = { "copilot.lua", "nvim-cmp" },
    enabled = lvim.user.copilot.active and lvim.user.copilot.cmp,
  },

  -- automatic session saver
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    -- module = "persistence",
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
    enabled = lvim.user.lastplace.active,
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    denpencies = "nvim-lua/plenary.nvim",
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

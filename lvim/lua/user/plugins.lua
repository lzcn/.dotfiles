lvim.plugins = {
  -- Aesthetics --
  -- colorscheme
  { "Mofiqul/dracula.nvim" },
  -- rainbow parentheses
  { "p00f/nvim-ts-rainbow" },
  -- display color
  { "norcalli/nvim-colorizer.lua" },

  { "mtdl9/vim-log-highlighting", ft = { "text", "log" }, disable = not lvim.user.log.active },
  {
    "chrisbra/csv.vim",
    ft = { "csv" },
    disable = not lvim.user.csv.active,
  },
  -- Git --
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    module = "diffview",
    event = "BufRead",
    keys = "<leader>gd",
    setup = function()
      require("which-key").register({ ["<leader>gd"] = "diffview: diff HEAD" })
    end,
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        key_bindings = {
          file_panel = { q = "<Cmd>DiffviewClose<CR>" },
          view = { q = "<Cmd>DiffviewClose<CR>" },
        },
      })
    end,
  },

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
    disable = not lvim.user.lsp_signature.active,
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
  -- open url
  {
    "felipec/vim-sanegx",
    event = "BufRead",
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
    disable = not lvim.user.tex.active,
  },
  {
    "kdheepak/cmp-latex-symbols",
    requires = "hrsh7th/nvim-cmp",
    ft = "tex",
    disable = not lvim.user.tex.active,
  },

  -- Markdown --
  -- preview with glow
  { "npxbr/glow.nvim", ft = { "markdown" }, disable = not lvim.user.markdown.glow },
  -- preview on browser
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 1
    end,
    disable = not lvim.user.markdown.preview,
  },

  -- Utility --
  -- indentline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("user.indentline").config()
    end,
    disable = not lvim.user.indentline.active,
  },

  -- copilot
  {
    "github/copilot.vim",
    config = function()
      require("user.cop").config()
    end,
    disable = not lvim.user.copilot.active or lvim.user.copilot.cmp,
  },
  {
    "abecodes/tabout.nvim",
    wants = { "nvim-treesitter" },
    after = { "nvim-cmp" },
    config = function()
      require("user.tabout").config()
    end,
    disable = not lvim.user.copilot.active or lvim.user.copilot.cmp,
  },
  {
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          plugin_manager_path = get_runtime_dir() .. "/site/pack/packer",
        })
      end, 100)
    end,
    disable = not lvim.user.copilot.active or not lvim.user.copilot.cmp,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua", "nvim-cmp" },
    disable = not lvim.user.copilot.active or not lvim.user.copilot.cmp,
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

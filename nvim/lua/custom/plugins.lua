-- custom plugins
local customPlugins = require "core.customPlugins"
customPlugins.add(function(use)
   -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
   use { "antoinemadec/FixCursorHold.nvim" }
   use { "williamboman/nvim-lsp-installer" }
   use { "tamago324/nlsp-settings.nvim" }
   use { "b0o/schemastore.nvim" }
   use { "dracula/vim", as = "dracula" }
   use { "github/copilot.vim" }
   use {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.null-ls").setup()
      end,
   }
   use { "folke/which-key.nvim" }
end)
--  Comment.nvim
--  LuaSnip
--  better-escape.nvim
--  bufferline.nvim
--  cmp-buffer
--  cmp-nvim-lsp
--  cmp-nvim-lua
--  cmp-path
--  cmp_luasnip
--  extensions
--  feline.nvim
--  friendly-snippets
--  gitsigns.nvim
--  indent-blankline.nvim
--  lsp_signature.nvim
--  nvim-autopairs
--  nvim-base16.lua
--  nvim-cmp
--  nvim-lspconfig
--  nvim-tree.lua
--  nvim-treesitter
--  nvim-web-devicons
--  packer.nvim
--  plenary.nvim
--  telescope.nvim
--  vim-matchup

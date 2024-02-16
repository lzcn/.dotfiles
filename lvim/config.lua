-- general options
vim.opt.scrolloff = 5
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- colorscheme
lvim.colorscheme = "onedark"

-- toggleterm
lvim.builtin.terminal.active = true

-- bufferline
lvim.builtin.bufferline.active = true
lvim.builtin.bufferline.options.always_show_bufferline = true

-- cmp-cmdline
lvim.builtin.cmp.cmdline.enable = true

-- nvim-navic
lvim.builtin.breadcrumbs.active = true

-- user settings
lvim.user = {
  copilot = { active = true, cmp = true },
  csv = { active = true },
  fcitx = { active = false },
  indentline = { active = true },
  lastplace = { active = true },
  log = { active = true },
  lsp = { format = { async = true, timeout_ms = 3000 }, signature = true },
  macos = vim.fn.has "macunix" > 0,
  magma = { active = false },
  markdown = { glow = false, preview = true },
  navigation = { lightspeed = false, numb = true, rnvimr = false },
  git = { diffview = false },
  wrapping = { active = false },
  tex = { active = true },
  trouble = { active = false },
}

require "user.plugins"

-- dap
require "user.dap"

-- lualine
require "user.lualine"

-- keymappings
require "user.keymaps"

-- telescope
require "user.telescope"

-- whichkey
require "user.whichkey"

-- dashboard
require "user.dashboard"

-- nvimtree
require "user.nvimtree"

-- gitsigns
require "user.gitsigns"

-- treesitter
require "user.treesitter"

-- lsp configurations
require "user.lsp"

-- null-ls configurations
require "user.null-ls"

-- autocommands
require "user.autocommands"

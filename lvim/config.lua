-- general options
vim.opt.scrolloff = 5
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- colorscheme
lvim.colorscheme = "tokyonight"
lvim.builtin.lualine.options.theme = "tokyonight"

-- toggleterm
lvim.builtin.terminal.active = true

-- bufferline
lvim.builtin.bufferline.active = true
lvim.builtin.bufferline.options.always_show_bufferline = true

-- lualine
lvim.builtin.lualine.options.globalstatus = true

-- cmp-cmdline
lvim.builtin.cmp.cmdline.enable = true

-- nvim-navic
lvim.builtin.breadcrumbs.active = false

-- debug adapter protocol
lvim.builtin.dap.active = false

-- plugins
lvim.user = {
  copilot = { active = true, cmp = true },
  csv = { active = false },
  cursorword = { active = false },
  fcitx = { active = false },
  indentline = { active = false },
  lastplace = { active = true },
  log = { active = false },
  lsp = { format = { async = true, timeout_ms = 3000 }, signature = true },
  macos = vim.fn.has "macunix" > 0,
  markdown = { glow = false, preview = true },
  navigation = { lightspeed = false, numb = true, rnvimr = false },
  git = { diffview = false },
  wrapping = { active = true },
  tex = { active = true },
  trouble = { active = false },
}

require "user.plugins"

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

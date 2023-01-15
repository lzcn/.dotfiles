-- vim options
vim.opt.scrolloff = 5
vim.opt.relativenumber = true
-- vim.opt.termguicolors = true

-- colorscheme
lvim.colorscheme = "dracula"

-- user configurations
lvim.user = {
  copilot = { active = true, cmp = true },
  csv = { active = true },
  fcitx = { active = false },
  indentline = { active = false },
  lastplace = { active = true },
  log = { active = true },
  lsp = { timeout_ms = 3000 },
  lsp_signature = { active = false },
  macos = vim.fn.has("macunix") > 0,
  markdown = { glow = false, preview = true },
  navigation = { lightspeed = false, numb = true, rnvimr = false },
  tex = { active = true },
}

-- plugins
require("user.plugins")

-- toggleterm
require("user.toggleterm")

-- keymappings
require("user.keymaps")

-- telescope
require("user.telescope")

-- whichkey
require("user.whichkey")

-- dashboard
require("user.dashboard")

-- bufferline
require("user.bufferline")

-- lualine
require("user.lualine")

-- nvimtree
require("user.nvimtree")

-- gitsigns
require("user.gitsigns")

-- treesitter
require("user.treesitter")

-- lsp configurations
require("user.lsp")

-- null-ls configurations
require("user.null-ls")

-- autocommands
require("user.autocommands")

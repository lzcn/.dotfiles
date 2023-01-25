-- general options
vim.opt.scrolloff = 5
vim.opt.termguicolors = true

-- colorscheme
lvim.colorscheme = "tokyonight"
lvim.builtin.lualine.options.theme = "tokyonight"

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

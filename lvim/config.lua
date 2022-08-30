-- general options
vim.opt.scrolloff = 5
vim.opt.relativenumber = true
vim.opt.termguicolors = true

lvim.format_on_save = false

-- colorscheme
lvim.colorscheme = "dracula"

-- user configurations
lvim.user = {
  copilot = { active = true, cmp = true },
  csv = { active = false },
  fcitx = { active = true },
  indentline = { active = true },
  lastplace = { active = true },
  log = { active = true },
  lsp = { timeout = 3000 },
  lsp_signature = { active = false },
  macos = vim.fn.has("macunix"),
  markdown = { glow = false, preview = true },
  navigation = { lightspeed = false, numb = false, rnvimr = false },
  tex = { active = true },
}

-- plugins
require("user.plugins")
-- copilot-cmp
if lvim.user.copilot.active and lvim.user.copilot.cmp then
  lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
  table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })
end

-- toggleterm
lvim.builtin.terminal.active = true
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "ipython", "<c-\\><c-p>", "iPython" }
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "node", "<c-\\><c-n>", "node" }
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "htop", "<c-\\><c-h>", "htop" }
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "ncdu", "<c-\\><c-u>", "ncdu" }

-- keymappings
require("user.keymaps")

-- telescope
require("user.telescope")

-- whichkey
require("user.whichkey")

-- dashboard
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.alpha.dashboard.section.header.val = {
  "                                                       ",
  "                                                       ",
  " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
  " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
  " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
  " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
  " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
  " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
  "                                                       ",
  "                                                       ",
}
local fortune = require("alpha.fortune")
lvim.builtin.alpha.dashboard.section.footer.val = fortune

-- notify
lvim.builtin.notify.active = false

-- buffline
lvim.builtin.bufferline.active = true
lvim.builtin.bufferline.options.always_show_bufferline = true

-- lualine
lvim.builtin.lualine.options.globalstatus = true
lvim.builtin.lualine.options.theme = "dracula-nvim"

-- nvimtree
lvim.builtin.nvimtree.setup.view.mappings.list = {
  { key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
  { key = "h", action = "close_node" },
  { key = "v", action = "vsplit" },
  { key = "C", action = "cd" },
}
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git = {
  deleted = "",
  ignored = "◌",
  renamed = "➜",
  staged = "✓",
  unmerged = "",
  unstaged = "✗",
  untracked = "★",
}

-- gitsigns
lvim.builtin.gitsigns.opts.signs.delete.text = "▎"
lvim.builtin.gitsigns.opts.signs.topdelete.text = "▎"

-- treesitter
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true

-- generic LSP settings
lvim.lsp.installer.setup.automatic_installation = true
lvim.lsp.diagnostics.virtual_text = false

-- null-ls configurations
require("user.null-ls")

-- autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

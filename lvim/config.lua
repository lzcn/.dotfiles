-- general options
lvim.colorscheme = "dracula"
lvim.format_on_save = false

vim.opt.scrolloff = 5
vim.opt.relativenumber = true
vim.o.termguicolors = true

-- additional plugins
lvim.user = {
  copilot = { active = true },
  lastplace = { active = true },
  navigation = { lightspeed = true, numb = false, rnvimr = true },
}
require("lv-user-config.plugins")

-- toggleterm
lvim.builtin.terminal.active = true
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "ipython", "<c-\\><c-p>", "iPython" }
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "node", "<c-\\><c-n>", "node" }
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "htop", "<c-\\><c-h>", "htop" }
lvim.builtin.terminal.execs[#lvim.builtin.terminal.execs + 1] = { "ncdu", "<c-\\><c-u>", "ncdu" }

-- keymappings
require("lv-user-config.keymaps")

-- telescope
require("lv-user-config.telescope")

-- whichkey
require("lv-user-config.whichkey")

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
lvim.builtin.alpha.dashboard.section.footer.val = require("alpha.fortune")()

-- notify
lvim.builtin.notify.active = false

-- buffline
lvim.builtin.bufferline.active = true
lvim.builtin.bufferline.options.always_show_bufferline = true

-- lualine
lvim.builtin.lualine.options.globalstatus = true
lvim.builtin.lualine.options.theme = "dracula-nvim"
-- use the same color for buffer bg
vim.g.dracula_lualine_bg_color = "#282A3"

-- nvimtree
lvim.builtin.nvimtree.setup.actions.open_file.resize_window = false
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
lvim.lsp.automatic_servers_installation = true
lvim.lsp.diagnostics.virtual_text = false

-- null-ls configurations
require("lv-user-config.null-ls")

-- autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

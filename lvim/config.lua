-- general options
lvim.colorscheme = "dracula"
-- use the same color for buffer bg
vim.g.dracula_lualine_bg_color = require("dracula").colors()["bg"]
-- set italic comment
vim.g.dracula_italic_comment = true

lvim.format_on_save = false

vim.opt.scrolloff = 5
vim.opt.relativenumber = true
vim.o.termguicolors = true

-- user plugins
lvim.user = {
  copilot = { active = true, cmp = true },
  indentline = { active = true },
  lastplace = { active = true },
  navigation = { lightspeed = true, numb = false, rnvimr = true },
}
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
require("user.null-ls")

-- autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

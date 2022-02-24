-- general options
require("lv-user-config.options")

-- additional plugins
require("lv-user-config.plugins")

-- lualine configurations
require("lv-user-config.lualine")

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
lvim.builtin.dashboard.active = true
lvim.builtin.dashboard.custom_header = {
	" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
}

-- notify
lvim.builtin.notify.active = false

-- buffline
lvim.builtin.bufferline.active = true
lvim.builtin.bufferline.options.always_show_bufferline = true

-- nvimtree
lvim.builtin.nvimtree.icons.git = {
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
lvim.builtin.treesitter.rainbow.enable = true

-- generic LSP settings
lvim.lsp.automatic_servers_installation = true
lvim.lsp.diagnostics.virtual_text = false

-- null-ls configurations
require("lv-user-config.null-ls")

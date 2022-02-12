-- general options
require("lv-user-config.options")

-- additional plugins
require("lv-user-config.plugins")

-- lualine configurations
require("lv-user-config.lualine")

-- toggleterm
lvim.builtin.terminal.active = true
-- toggleterm configurations
require("lv-user-config.terminal")

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
lvim.builtin.gitsigns.opts.numhl = false
lvim.builtin.gitsigns.opts.signs.add.text = "│"
lvim.builtin.gitsigns.opts.signs.change.text = "│"
lvim.builtin.gitsigns.opts.signs.delete.text = "│"
lvim.builtin.gitsigns.opts.signs.topdelete.text = "│"
lvim.builtin.gitsigns.opts.signs.changedelete = "│"

-- treesitter
lvim.builtin.treesitter.ensure_installed = { "lua", "vim", "python", "bash", "yaml", "css", "typescript" }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.rainbow.enable = true

-- generic LSP settings
lvim.lsp.automatic_servers_installation = true
lvim.lsp.diagnostics.virtual_text = false

-- null-ls configurations
require("lv-user-config.null-ls")

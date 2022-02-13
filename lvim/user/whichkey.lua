-- visual mode --
lvim.builtin.which_key.vmappings["p"] = { '"_dP', "Replace" }

-- normal mode --
lvim.builtin.which_key.mappings["q"] = { "<cmd>q<CR>", "Quit" }

-- telescope.lua
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["r"] = { "<cmd>Telescope oldfiles<CR>", "Recent Files" }

-- trouble
lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnostics" },
}

-- sessions
lvim.builtin.which_key.mappings["S"] = {
	name = "Session",
	c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
	l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
	s = { "<cmd>lua require('persistence').save()<cr>", "Save session" },
	a = { "<cmd>lua require('persistence').start()<cr>", "Automatically save when leave" },
	Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}

-- nvim-tree.lua
lvim.builtin.which_key.mappings["e"] = { "<cmd>NvimTreeFocus<CR>", "Explorer" }
-- telescope.lua
lvim.builtin.which_key.mappings["r"] = { "<cmd>Telescope oldfiles<cr>", "Recent Files" }
lvim.builtin.which_key.mappings["s"]["g"] = { "<cmd>Telescope live_grep<cr>", "Text" }
lvim.builtin.which_key.mappings["s"]["b"] = { "<cmd>Telescope buffers<cr>", "Buffer" }

-- todo-comments.nvim
lvim.builtin.which_key.mappings["s"]["t"] = { "<cmd>TodoTelescope keywords=TODO,FIX<cr>", "Todo" }

-- buffers
lvim.builtin.which_key.mappings["b"]["o"] =
  { "<cmd>BufferLineCloseRight<cr><cmd>BufferLineCloseLeft<cr>", "Close other buffers" }

-- override timeout
lvim.builtin.which_key.mappings["l"]["f"] = {
  function()
    -- require("lvim.lsp.utils").format(lvim.user.lsp.format)
    require("conform").format()
  end,
  "Format",
}

-- trouble.nvim
if lvim.user.trouble.active then
  lvim.builtin.which_key.mappings["t"] = {
    name = "Trouble",
    r = { "<cmd>Trouble lsp_references<cr>", "References" },
    f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
    d = { "<cmd>Trouble document_diagnostics<cr>", "Document Diagnostics" },
    q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
    l = { "<cmd>Trouble loclist<cr>", "LocationList" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
  }
end

-- persistence.nvim
lvim.builtin.which_key.mappings["S"] = {
  name = "Session",
  c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
  l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
  s = { "<cmd>lua require('persistence').save()<cr>", "Save session" },
  a = { "<cmd>lua require('persistence').start()<cr>", "Automatically save when leave" },
  Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
}
-- python env
lvim.builtin.which_key.mappings["C"] = {
  name = "Env",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Change Python Interpreter" },
}

lvim.leader = "space"
vim.g.maplocalleader = "\\"

-- normal mode --
-- navigate buffers use Tab to navigate buffer instead H/L
lvim.keys.normal_mode["<S-l>"] = false
lvim.keys.normal_mode["<S-h>"] = false
lvim.keys.normal_mode["<Tab>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":BufferLineCyclePrev<CR>"

-- magama.nvim
lvim.keys.visual_mode["<LocalLeader>r"] = ":<C-u>MagmaEvaluateVisual<CR>"
lvim.keys.normal_mode["<Localleader>r"] = ":MagmaEvaluateOperator<CR>"
lvim.keys.normal_mode["<Localleader>rr"] = ":MagmaEvaluateLine<CR>"
lvim.keys.normal_mode["<LocalLeader>rc"] = ":MagmaReevaluateCell<CR>"
lvim.keys.normal_mode["<LocalLeader>rd"] = ":MagmaDelete<CR>"
lvim.keys.normal_mode["<LocalLeader>ro"] = ":MagmaShowOutput<CR>"

-- pydocstring
lvim.keys.normal_mode["<C-_>"] = "<Plug>(pydocstring)"

-- navigator
lvim.keys.normal_mode["<C-a>h"] = "<CMD>lua require('Navigator').left()<CR>"
lvim.keys.normal_mode["<C-a>k"] = "<CMD>lua require('Navigator').up()<CR>"
lvim.keys.normal_mode["<C-a>l"] = "<CMD>lua require('Navigator').right()<CR>"
lvim.keys.normal_mode["<C-a>j"] = "<CMD>lua require('Navigator').down()<CR>"
lvim.keys.normal_mode["<C-a>p"] = "<CMD>lua require('Navigator').previous()<CR>"

-- insert mode --
-- navigation within insert mode
lvim.keys.insert_mode["<C-h>"] = { "<left>", { noremap = true } }
lvim.keys.insert_mode["<C-l>"] = { "<Right>", { noremap = true } }
lvim.keys.insert_mode["<C-k>"] = { "<Up>", { noremap = true } }
lvim.keys.insert_mode["<C-j>"] = { "<Down>", { noremap = true } }
lvim.keys.insert_mode["<C-e>"] = "<End>"
lvim.keys.insert_mode["<C-a>"] = "<Esc>^i"

if lvim.user.copilot.active then
	local cmp = require("cmp")
	local function t(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	lvim.builtin.cmp.mapping["<C-v>"] = cmp.mapping(function()
		vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t("<Tab>")), "n", true)
	end)
	lvim.keys.insert_mode["<M-]>"] = { "<Plug>(copilot-next)", { silent = true } }
	lvim.keys.insert_mode["<M-[>"] = { "<Plug>(copilot-previous)", { silent = true } }
	lvim.keys.insert_mode["<M-\\>"] = { "<Cmd>vertical Copilot panel<CR>", { silent = true } }
end
-- disable jj and kj for <Esc>
lvim.keys.insert_mode["jj"] = false
lvim.keys.insert_mode["kj"] = false

-- visual mode
lvim.keys.visual_mode["p"] = '"_dP'

-- terminal mode
lvim.keys.term_mode["<esc>"] = [[<C-\><C-n>]]

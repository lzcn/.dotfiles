-- Modified from https://github.com/abzcoding/lvim/blob/main/lua/user/builtin.lua
local M = {}

M.config = function()
	local cmp = require("cmp")
	lvim.keys.insert_mode["<c-e>"] = { [[copilot#Accept("\<CR>")]], { expr = true, script = true } }
	lvim.keys.insert_mode["<M-]>"] = { "<Plug>(copilot-next)", { silent = true } }
	lvim.keys.insert_mode["<M-[>"] = { "<Plug>(copilot-previous)", { silent = true } }
	lvim.keys.insert_mode["<M-\\>"] = { "<Cmd>vertical Copilot panel<CR>", { silent = true } }
	lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(M.tab, { "i", "c" })
	lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(M.shift_tab, { "i", "c" })
	vim.g.copilot_assume_mapped = true
	vim.g.copilot_no_tab_map = true
	vim.g.copilot_tab_fallback = ""
end

function M.tab(fallback)
	local methods = require("lvim.core.cmp").methods
	local luasnip = require("luasnip")
	local cmp = require("cmp")
	local copilot_keys = vim.fn["copilot#Accept"]()
	if cmp.visible() then
		cmp.select_next_item()
	elseif vim.api.nvim_get_mode().mode == "c" then
		fallback()
	elseif copilot_keys ~= "" then -- prioritise copilot over snippets
		-- Copilot keys do not need to be wrapped in termcodes
		vim.api.nvim_feedkeys(copilot_keys, "i", true)
	elseif luasnip.expandable() then
		luasnip.expand()
	elseif methods.jumpable() then
		luasnip.jump(1)
	elseif methods.check_backspace() then
		fallback()
	else
		methods.feedkeys("<Plug>(Tabout)", "")
	end
end

function M.shift_tab(fallback)
	local methods = require("lvim.core.cmp").methods
	local luasnip = require("luasnip")
	local cmp = require("cmp")
	if cmp.visible() then
		cmp.select_prev_item()
	elseif vim.api.nvim_get_mode().mode == "c" then
		fallback()
	elseif methods.jumpable(-1) then
		luasnip.jump(-1)
	else
		local copilot_keys = vim.fn["copilot#Accept"]()
		if copilot_keys ~= "" then
			methods.feedkeys(copilot_keys, "i")
		else
			methods.feedkeys("<Plug>(Tabout)", "")
		end
	end
end

return M

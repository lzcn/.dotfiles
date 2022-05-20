-- modified from https://github.com/abzcoding/lvim/blob/main/lua/user/builtin.lua
local M = {}
M.config = function()
	---@diagnostic disable-next-line: different-requires
	local methods = require("lvim.core.cmp").methods
	local status_cmp_ok, cmp = pcall(require, "cmp")
	if not status_cmp_ok then
		return
	end
	local status_luasnip_ok, luasnip = pcall(require, "luasnip")
	if not status_luasnip_ok then
		return
	end
	vim.g.copilot_no_tab_map = true
	vim.g.copilot_assume_mapped = true
	vim.g.copilot_tab_fallback = ""
	lvim.builtin.cmp.mapping["<Tab>"] = cmp.mapping(function(fallback)
		local copilot_keys = vim.fn["copilot#Accept"]()
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expandable() then
			luasnip.expand()
		elseif methods.jumpable() then
			luasnip.jump(1)
		elseif methods.is_emmet_active() then
			return vim.fn["cmp#complete"]()
		elseif copilot_keys ~= "" then -- prioritise copilot over snippets
			-- Copilot keys do not need to be wrapped in termcodes
			vim.api.nvim_feedkeys(copilot_keys, "i", true)
		elseif methods.check_backspace() then
			fallback()
		else
			methods.feedkeys("<Plug>(Tabout)", "")
		end
	end, { "i", "s" })
	---@diagnostic disable-next-line: unused-local
	lvim.builtin.cmp.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
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
	end, { "i", "s" })
end

return M

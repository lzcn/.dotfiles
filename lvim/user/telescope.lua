-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.

local ok, actions = pcall(require, "telescope.actions")
if ok then
	lvim.builtin.telescope.defaults.mappings = {
		-- for input mode
		i = {
			["<C-j>"] = actions.move_selection_next,
			["<C-k>"] = actions.move_selection_previous,
			["<C-n>"] = actions.cycle_history_next,
			["<C-p>"] = actions.cycle_history_prev,
		},
		-- for normal mode
		n = {
			["<C-j>"] = actions.move_selection_next,
			["<C-k>"] = actions.move_selection_previous,
		},
	}
else
	print("Telescope not loaded.")
end

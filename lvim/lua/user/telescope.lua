local status_ok, actions = pcall(require, "telescope.actions")

if not status_ok then
  print("Telescope not loaded.")
  return
end

lvim.builtin.telescope.defaults.prompt_prefix = " "
-- use j/k to move selection and p/n to cycle history
lvim.builtin.telescope.defaults.mappings["i"]["<C-j>"] = actions.move_selection_next
lvim.builtin.telescope.defaults.mappings["i"]["<C-k>"] = actions.move_selection_previous
lvim.builtin.telescope.defaults.mappings["i"]["<C-n>"] = actions.cycle_history_next
lvim.builtin.telescope.defaults.mappings["i"]["<C-p>"] = actions.cycle_history_prev
lvim.builtin.telescope.defaults.mappings["n"]["<C-j>"] = actions.move_selection_next
lvim.builtin.telescope.defaults.mappings["n"]["<C-k>"] = actions.move_selection_previous

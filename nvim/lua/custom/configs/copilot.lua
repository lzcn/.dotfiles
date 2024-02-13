--type copilot.options
local options = {
  suggestion = {
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<C-f>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  panel = {
    auto_refresh = true,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>",
    },
    layout = {
      position = "right",
      ratio = 0.4,
    },
  },
  filetypes = {
    yaml = true,
    mardown = true,
    gitcommit = false,
  },
}
vim.defer_fn(function()
  require("copilot").setup(options)
  require("copilot_cmp").setup()
end, 100)

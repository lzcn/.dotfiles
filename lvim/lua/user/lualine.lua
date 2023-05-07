local components = require "lvim.core.lualine.components"

lvim.builtin.lualine.style = "lvim"
lvim.builtin.lualine.options.theme = lvim.colorscheme
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  components.python_env,
  "filename",
}
lvim.builtin.lualine.options.globalstatus = true

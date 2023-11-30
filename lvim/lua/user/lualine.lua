local components = require "lvim.core.lualine.components"

lvim.builtin.lualine.style = "lvim"
if string.find(lvim.colorscheme, "dracula") then
  lvim.builtin.lualine.options.theme = "dracula-nvim"
elseif string.find(lvim.colorscheme, "tokyonight") then
  lvim.builtin.lualine.options.theme = "tokyonight"
end
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  components.python_env,
  "filename",
}
lvim.builtin.lualine.options.globalstatus = true

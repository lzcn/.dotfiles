local components = require "lvim.core.lualine.components"

-- change lualine theme
if string.find(lvim.colorscheme, "dracula") then
  lvim.builtin.lualine.options.theme = "dracula-nvim"
elseif string.find(lvim.colorscheme, "tokyonight") then
  lvim.builtin.lualine.options.theme = "tokyonight"
else
  lvim.builtin.lualine.options.theme = lvim.colorscheme
end
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_c = {
  components.diff,
  components.python_env,
  components.filename,
  -- "filename",
}
-- lvim.builtin.lualine.style = "lvim"
-- lvim.builtin.lualine.options.globalstatus = true

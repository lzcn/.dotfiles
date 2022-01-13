vim.cmd [[
try
  colorscheme dracula
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

-- Transparent window
-- vim.cmd [[
-- au ColorScheme * hi Normal ctermbg=none guibg=none
-- au ColorScheme * hi SignColumn ctermbg=none guibg=none
-- au ColorScheme * hi NormalNC ctermbg=none guibg=none
-- au ColorScheme * hi MsgArea ctermbg=none guibg=none
-- au ColorScheme * hi TelescopeBorder ctermbg=none guibg=none
-- au ColorScheme * hi NvimTreeNormal ctermbg=none guibg=none
-- let &fcs='eob:
-- ]]

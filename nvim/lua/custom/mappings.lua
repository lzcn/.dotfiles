---@type MappingsTable
local M = {}
M.disabled = {
  -- disable some default mappings
  n = {
    ["<leader>b"] = "",
    ["<leader>ca"] = "",
    ["<leader>ch"] = "",
    ["<leader>cm"] = "",
    ["<leader>D"] = "",
    ["<leader>fa"] = "",
    ["<leader>fb"] = "",
    ["<leader>ff"] = "",
    ["<leader>fg"] = "",
    ["<leader>fh"] = "",
    ["<leader>fm"] = "",
    ["<leader>fo"] = "",
    ["<leader>fw"] = "",
    ["<leader>fz"] = "",
    ["<leader>gb"] = "",
    ["<leader>gt"] = "",
    ["<leader>h"] = "",
    ["<leader>lf"] = "",
    ["<leader>ls"] = "",
    ["<leader>ma"] = "",
    ["<leader>n"] = "",
    ["<leader>ph"] = "",
    ["<leader>q"] = "",
    ["<leader>ra"] = "",
    ["<leader>rh"] = "",
    ["<leader>rn"] = "",
    ["<leader>td"] = "",
    ["<leader>th"] = "",
    ["<leader>v"] = "",
    ["<leader>wa"] = "",
    ["<leader>wk"] = "",
    ["<leader>wK"] = "",
    ["<leader>wl"] = "",
    ["<leader>wr"] = "",
    ["<leader>x"] = "",
  },
  v = {
    ["<leader>ca"] = "",
  },
}
local generic_opts = {
  n = {
    noremap = true,
    silent = true,
  },
  i = {
    noremap = true,
    silent = true,
  },
  v = {
    noremap = true,
    silent = true,
  },
  x = {
    noremap = true,
    silent = true,
  },
  t = {
    expr = true,
  },
}
M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    -- Resize with arrows
    ["<A-Up>"] = { ":resize -2<CR>", "resize up", opts = generic_opts.n },
    ["<A-Down>"] = { ":resize +2<CR>", "resize down", opts = generic_opts.n },
    ["<A-Left>"] = { ":vertical resize -2<CR>", "resize left", opts = generic_opts.n },
    ["<A-Right>"] = { ":vertical resize +2<CR>", "resize right", opts = generic_opts.n },
    -- Move current line / block with Alt-j/k a la vscode.
    ["<A-j>"] = { ":m .+1<CR>==", "move line down", opts = generic_opts.n },
    ["<A-k>"] = { ":m .-2<CR>==", "move line up", opts = generic_opts.n },
    -- QuickFix
    ["]q"] = { ":cnext<CR>", "next QuickFix", opts = generic_opts.n },
    ["[q"] = { ":cprev<CR>", "previous QuickFix", opts = generic_opts.n },
    ["<C-q>"] = { ":call QuickFixToggle()<CR>", "toggle QuickFix", opts = generic_opts.n },
    -- Debugging with nvim-dap
    ["<leader>h"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint", opts = generic_opts.n },
    ["<F5>"] = { "<cmd>lua require'dap'.continue()<cr>", "dap continue", opts = generic_opts.n },
    ["<F6>"] = { "<cmd>lua require'dap'.pause()<cr>", "dap pause", opts = generic_opts.n },
    ["<F10>"] = { "<cmd>lua require'dap'.step_over()<cr>", "dap step over", opts = generic_opts.n },
    ["<F11>"] = { "<cmd>lua require'dap'.step_into()<cr>", "dap step into", opts = generic_opts.n },
    ["<F12>"] = { "<cmd>lua require'dap'.step_out()<cr>", "dap step out", opts = generic_opts.n },
  },
  i = {
    ["<A-j>"] = { "<Esc>:m .+1<CR>==gi", "move line down in insert mode", opts = generic_opts.i },
    ["<A-k>"] = { "<Esc>:m .-2<CR>==gi", "move line up in insert mode", opts = generic_opts.i },
    ["<A-Up>"] = { "<C-\\><C-N><C-w>k", "move cursor up in insert mode", opts = generic_opts.i },
    ["<A-Down>"] = { "<C-\\><C-N><C-w>j", "move cursor down in insert mode", opts = generic_opts.i },
    ["<A-Left>"] = { "<C-\\><C-N><C-w>h", "move cursor left in insert mode", opts = generic_opts.i },
    ["<A-Right>"] = { "<C-\\><C-N><C-w>l", "move cursor right in insert mode", opts = generic_opts.i },
  },
  v = {
    [">"] = { ">gv", "indent", opts = generic_opts.v },
    ["<"] = { "<gv", "unindent", opts = generic_opts.v },
  },
  x = {
    ["<A-j>"] = { ":m '>+1<CR>gv-gv", "move line down in visual mode", opts = generic_opts.v },
    ["<A-k>"] = { ":m '<-2<CR>gv-gv", "move line up in visual mode", opts = generic_opts.v },
  },
}

return M

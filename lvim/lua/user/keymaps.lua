lvim.leader = "space"
vim.g.maplocalleader = "\\"

-- normal mode --
lvim.keys.normal_mode["<Esc>"] = ":noh<CR>"
lvim.keys.normal_mode["<C-n>"] = ":NvimTreeToggle<CR>"
lvim.keys.normal_mode["<Tab>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode[";"] = ":"
lvim.keys.normal_mode["<C-k>"] = "<cmd> lua require('lsp_signature').toggle_float_win()<CR>" -- show signature help

lvim.keys.normal_mode["<leader>h"] = "<cmd>lua require'dap'.toggle_breakpoint()<cr>"
lvim.keys.normal_mode["<F5>"] = "<cmd>lua require'dap'.continue()<cr>"
lvim.keys.normal_mode["<F6>"] = "<cmd>lua require'dap'.pause()<cr>"
lvim.keys.normal_mode["<F10>"] = "<cmd>lua require'dap'.step_over()<cr>"
lvim.keys.normal_mode["<F11>"] = "<cmd>lua require'dap'.step_into()<cr>"
lvim.keys.normal_mode["<F12>"] = "<cmd>lua require'dap'.step_out()<cr>"
-- magama.nvim
if lvim.user.magma.active then
  lvim.keys.visual_mode["<LocalLeader>r"] = ":<C-u>MagmaEvaluateVisual<CR>"
  lvim.keys.normal_mode["<Localleader>r"] = ":MagmaEvaluateOperator<CR>"
  lvim.keys.normal_mode["<Localleader>rr"] = ":MagmaEvaluateLine<CR>"
  lvim.keys.normal_mode["<Localleader>rc"] = ":MagmaReevaluateCell<CR>"
  lvim.keys.normal_mode["<Localleader>rd"] = ":MagmaDelete<CR>"
  lvim.keys.normal_mode["<Localleader>ro"] = ":MagmaShowOutput<CR>"
end

-- pydocstring
-- lvim.keys.normal_mode["<C-_>"] = "<Plug>(pydocstring)"

-- navigator
lvim.keys.normal_mode["<C-a>h"] = "<CMD>lua require('Navigator').left()<CR>"
lvim.keys.normal_mode["<C-a>k"] = "<CMD>lua require('Navigator').up()<CR>"
lvim.keys.normal_mode["<C-a>l"] = "<CMD>lua require('Navigator').right()<CR>"
lvim.keys.normal_mode["<C-a>j"] = "<CMD>lua require('Navigator').down()<CR>"
lvim.keys.normal_mode["<C-a>p"] = "<CMD>lua require('Navigator').previous()<CR>"

-- DAP

-- insert mode --

-- navigation within insert mode
lvim.keys.insert_mode["<C-h>"] = "<Left>"
lvim.keys.insert_mode["<C-l>"] = "<Right>"
lvim.keys.insert_mode["<C-k>"] = "<Up>"
lvim.keys.insert_mode["<C-j>"] = "<Down>"
lvim.keys.insert_mode["<C-e>"] = "<End>"
lvim.keys.insert_mode["<C-a>"] = "<Esc>^i"

-- visual mode --
lvim.keys.visual_mode["p"] = '"_dP'

-- terminal mode --
lvim.keys.term_mode["<C-x>"] = [[<C-\><C-n>]]

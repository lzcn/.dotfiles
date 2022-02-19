lvim.leader = "space"

-- normal mode --
-- navigate buffers use Tab to navigate buffer instead H/L
lvim.keys.normal_mode["<S-l>"] = false
lvim.keys.normal_mode["<S-h>"] = false
lvim.keys.normal_mode["<Tab>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":BufferLineCyclePrev<CR>"

-- pydocstring
lvim.keys.normal_mode["<c-_>"] = "<Plug>(pydocstring)"

-- navigator
lvim.keys.normal_mode["<C-a>h"] = "<CMD>lua require('Navigator').left()<CR>"
lvim.keys.normal_mode["<C-a>k"] = "<CMD>lua require('Navigator').up()<CR>"
lvim.keys.normal_mode["<C-a>l"] = "<CMD>lua require('Navigator').right()<CR>"
lvim.keys.normal_mode["<C-a>j"] = "<CMD>lua require('Navigator').down()<CR>"
lvim.keys.normal_mode["<C-a>p"] = "<CMD>lua require('Navigator').previous()<CR>"

-- insert mode --
-- navigation within insert mode
lvim.keys.insert_mode["<C-h>"] = "<Left>"
lvim.keys.insert_mode["<C-l>"] = "<Right>"
lvim.keys.insert_mode["<C-k>"] = "<Up>"
lvim.keys.insert_mode["<C-j>"] = "<Down>"
lvim.keys.insert_mode["<C-e>"] = "<End>"
lvim.keys.insert_mode["<C-a>"] = "<Esc>^i"

-- disable jj and kj for <Esc>
lvim.keys.insert_mode["jj"] = false
lvim.keys.insert_mode["kj"] = false

-- visual mode
lvim.keys.visual_mode["p"] = '"_dP'

-- terminal mode
lvim.keys.term_mode["<esc>"] = [[<C-\><C-n>]]

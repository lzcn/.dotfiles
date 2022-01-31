lvim.leader = "space"

-- normal mode --
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Navigate buffers
-- disable H and L and use Tab to navigate buffer
lvim.keys.normal_mode["<S-l>"] = false
lvim.keys.normal_mode["<S-h>"] = false
lvim.keys.normal_mode["<Tab>"] = ":BufferNext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":BufferPrevious<CR>"

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

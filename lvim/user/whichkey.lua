-- telescope.lua
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- toggleterm.lua
lvim.builtin.which_key.mappings["t"] = {
    name = "+Terminal",
    n = { "<cmd>lua _NODE_TOGGLE()<cr>", "node" },
    u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "ncdu" },
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<cr>", "LazyGit" },
    t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "htop" },
    p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "IPython" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "vertical" },
}


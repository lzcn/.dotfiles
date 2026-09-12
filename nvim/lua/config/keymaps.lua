-- Add any additional keymaps here
local map = vim.keymap.set

-- Open file
map("n", "<A-o>", LazyVim.pick("files"), { desc = "Find Files" })

-- Format file using vscode keymap
map("n", "<A-F>", function() LazyVim.format({ force = true }) end, { desc = "Format" })

-- Join lines without moving the cursor
map("n", "J", "mzJ`z", { desc = "Join Lines" })

-- Yank to end of line, consistent with D/C
map("n", "Y", "y$", { desc = "Yank to End of Line" })

-- Center the view after scrolling half a page
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down and Center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up and Center" })

-- Paste over a visual selection without losing the yanked text
map("x", "p", '"_dP', { desc = "Paste Without Yanking" })

-- Navigate windows from terminal mode, same keys as everywhere else
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to Left Window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to Lower Window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to Upper Window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to Right Window" })


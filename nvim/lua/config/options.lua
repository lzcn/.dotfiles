-- Disable autoformatting
vim.g.autoformat = false
vim.g.snacks_animate = false

-- Use the working directory instead of detecting a project root from each file.
vim.g.root_spec = {"cwd"}

-- Use the system clipboard for all operations
vim.opt.clipboard = "unnamedplus"

-- Wrap long text; LazyVim already moves j/k by display lines without a count.
vim.opt.wrap = true

lvim.builtin.nvimtree.setup.view.mappings.list = {
  { key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
  { key = "h", action = "close_node" },
  { key = "v", action = "vsplit" },
  { key = "C", action = "cd" },
}
lvim.builtin.nvimtree.setup.filesystem_watchers = {
  enable = false,
}
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git = {
  deleted = "",
  ignored = "◌",
  renamed = "➜",
  staged = "✓",
  unmerged = "",
  unstaged = "✗",
  untracked = "★",
}

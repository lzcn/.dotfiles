-- kitty <-> Neovim integration

return {
  -- <C-h/j/k/l> move seamlessly between Neovim splits and kitty windows/tmux panes
  -- <A-h/j/k/l> resize splits
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      ignored_filetypes = { "neo-tree" },
      default_amount = 5,
    },
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to below window" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to above window" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
      { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize left" },
      { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize down" },
      { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize up" },
      { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize right" },
    },
  },

  -- Switch clipboard to OSC 52 over SSH:
  -- yanks are synced through tmux (allow-passthrough) -> kitty (clipboard_control) to the local clipboard
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
        vim.g.clipboard = {
          name = "OSC 52",
          copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
          },
          paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
            ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
          },
        }
      end
      return opts
    end,
  },
}

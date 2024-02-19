local M = {
  nopts = {
    mode = "n",     -- NORMAL mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true   -- use `nowait` when creating keymaps
  },
  vopts = {
    mode = "v",     -- VISUAL mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true   -- use `nowait` when creating keymaps
  },

  nkeys = {
    ["/"] = { "<cmd>lua require'Comment.api'.toggle.linewise.current()<cr>", "Toggle comment" },
    ["f"] = { "<cmd>Telescope find_files<cr>", "Find File" },
    ["h"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    ["r"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    ["q"] = { "<cmd>confirm q<CR>", "Quit" },
    ["w"] = { "<cmd>w<cr>", "Save" },
    ["x"] = { "<cmd>lua require 'nvchad.tabufline'.close_buffer()<cr>", "Close Buffer" },
    b = {
      name = "Buffers",
      f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
      b = { "<cmd>enew<cr>", "New buffer" },
      W = { "<cmd>noautocmd w<cr>", "Save without formatting (rnoautocmd)" },
      p = { "<cmd>lua require('nvchad.tabufline').tabuflinePrev()<cr>", "Previous" },
      n = { "<cmd>lua require('nvchad.tabufline').tabuflineNext()<cr>", "Next" },
      e = { "<cmd>lua require('nvchad.tabufline').close_buffer()<cr>", "Pick which buffer to close" },
      o = { "<cmd>lua require('nvchad.tabufline').closeOtherBufs()<cr>", "Close other buffers" },
      h = { "<cmd>lua require('nvchad.tabufline').closeBufs_at_direction('left')<cr>", "Close all to the left" },
      l = { "<cmd>lua require('nvchad.tabufline').closeBufs_at_direction('right')<cr>", "Close all to the right" },
    },
    C = {
      name = "Env",
      c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Change Python Interpreter" },
    },
    d = {
      name = "Debug",
      t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
      b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
      c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
      C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
      d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
      g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
      i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
      o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
      u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
      p = { "<cmd>lua require'dap'.pause()<cr>", "Pause" },
      r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
      s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
      q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
      U = { "<cmd>lua require'dapui'.toggle({reset = true})<cr>", "Toggle UI" },
    },
    p = {
      name = "Plugins",
      i = { "<cmd>Lazy install<cr>", "Install" },
      s = { "<cmd>Lazy sync<cr>", "Sync" },
      S = { "<cmd>Lazy clear<cr>", "Status" },
      c = { "<cmd>Lazy clean<cr>", "Clean" },
      u = { "<cmd>Lazy update<cr>", "Update" },
      p = { "<cmd>Lazy profile<cr>", "Profile" },
      l = { "<cmd>Lazy log<cr>", "Log" },
      d = { "<cmd>Lazy debug<cr>", "Debug" },
    },
    g = {
      name = "Git",
      g = { "<cmd>LazyGit<cr>", "Lazygit" },
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)" },
      c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
      d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Git Diff" },
      j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
      k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
      l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
      t = { "<cmd>Telescope git_status<cr>", "Git status" },
      p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
      R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
      r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
      s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
      u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    },
    l = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
      d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
      w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
      -- f = { "<cmd>lua vim.lsp.buf.format { async = true }<cr>", "Format" },
      f = { "<cmd>lua require('conform').format()<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      I = { "<cmd>Mason<cr>", "Mason Info" },
      j = { "<cmd>lua vim.diagnostic.goto_next { float = { border = 'rounded' } }<cr>", "Next Diagnostic" },
      k = { "<cmd>lua vim.diagnostic.goto_prev { float = { border = 'rounded' } }<cr>", "Prev Diagnostic" },
      l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
      q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
      r = { "<cmd>lua require('nvchad.renamer').open()<cr>", "Rename" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
      e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    },
    s = {
      name = "Search",
      a = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", "Find all" },
      b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
      c = { "<cmd>Telescope themes<cr>", "Nvchad themes" },
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
      H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
      m = { "<cmd>Telescope marks<CR>", "telescope bookmarks" },
      M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      R = { "<cmd>Telescope registers<cr>", "Registers" },
      t = { "<cmd>Telescope live_grep<cr>", "Text" },
      k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
      C = { "<cmd>Telescope commands<cr>", "Commands" },
      l = { "<cmd>Telescope resume<cr>", "Resume last search" },
      z = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find in current buffer" },
      -- p = {"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", "Colorscheme with Preview"}
    },
    -- persistence.nvim
    S = {
      name = "Session",
      c = { "<cmd>lua require('persistence').load()<cr>", "Restore last session for current dir" },
      l = { "<cmd>lua require('persistence').load({ last = true })<cr>", "Restore last session" },
      s = { "<cmd>lua require('persistence').save()<cr>", "Save session" },
      a = { "<cmd>lua require('persistence').start()<cr>", "Automatically save when leave" },
      Q = { "<cmd>lua require('persistence').stop()<cr>", "Quit without saving session" },
    },
    -- trouble.nvim
    t = {
      name = "Trouble",
      r = { "<cmd>Trouble lsp_references<cr>", "References" },
      f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
      d = { "<cmd>Trouble document_diagnostics<cr>", "Document Diagnostics" },
      q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
      l = { "<cmd>Trouble loclist<cr>", "LocationList" },
      w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
    },
    T = {
      name = "Treesitter",
      i = { ":TSConfigInfo<cr>", "Info" },
    },
  },
  -- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
  -- see https://neovim.io/doc/user/map.html#:map-cmd
  vkeys = {
    ["/"] = { "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Toggle comment" },
    l = {
      name = "LSP",
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    },
  },
}

return M

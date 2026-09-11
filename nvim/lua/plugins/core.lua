return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        beautysh = {
          prepend_args = { "-i", "2" },
        },
        black = {
          prepend_args = { "--line-length", "120" },
        },
      },
      formatters_by_ft = {
        ["python"] = { "isort", "black" },
        ["sh"] = { "shfmt" },
        ["zsh"] = { "beautysh" },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = true,
          hide_gitignored = true,
        },
      },
    },
    init = function()
      -- Show dotfiles that Git tracks; keep untracked ones hidden.
      -- hide_dotfiles marks every dotfile; this wrapper strips the mark when
      -- the path is known to Git. Cache is one `git ls-files` per repo root.
      local file_items = require("neo-tree.sources.common.file-items")
      local base_create_item = file_items.create_item
      local tracked_cache = {}

      local function tracked_dots(root)
        local cached = tracked_cache[root]
        if cached then
          return cached
        end
        cached = {}
        local out = vim.fn.systemlist({ "git", "-C", root, "ls-files", "--full-name" })
        if vim.v.shell_error == 0 then
          for _, rel in ipairs(out) do
            local prefix = ""
            for part in rel:gmatch("[^/]+") do
              if part:sub(1, 1) == "." then
                cached[prefix .. part] = true
              end
              prefix = prefix .. part .. "/"
            end
          end
        end
        tracked_cache[root] = cached
        return cached
      end

      file_items.create_item = function(context, path, _type, bufnr)
        local item = base_create_item(context, path, _type, bufnr)
        local fby = item.filtered_by
        if fby and fby.dotfiles then
          local root = context.state.path or vim.fn.getcwd()
          if path:sub(1, #root + 1) == root .. "/" then
            local rel = path:sub(#root + 2)
            local tracked = tracked_dots(root)
            local hit = tracked[rel] ~= nil
            if not hit then -- directories like .github
              local prefix = ""
              for part in rel:gmatch("[^/]+") do
                prefix = prefix .. part .. "/"
                if tracked[prefix:sub(1, -2)] then
                  hit = true
                  break
                end
              end
            end
            if hit then
              fby.dotfiles = nil
              if next(fby) == nil then
                item.filtered_by = nil
              end
            end
          end
        end
        return item
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            pyright = { disableOrganizeImports = true },
            python = { analysis = { typeCheckingMode = "basic", ignore = { "*" } } },
          },
        },
        ruff_lsp = { settings = { lint = { enable = false } } },
      },
    },
  },
}

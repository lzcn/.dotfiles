local null_ls = require "null-ls"
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local sources = {

   formatting.prettierd.with { filetypes = { "html", "markdown", "css" } },
   formatting.deno_fmt,
   -- Python
   formatting.black,
   diagnostics.flake8,

   -- Lua

   formatting.stylua,

   -- Shell
   formatting.shfmt,
   diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

local M = {}

M.setup = function()
   null_ls.setup {
      debug = true,
      sources = sources,
      -- format on save
      on_attach = function(client)
         if client.resolved_capabilities.document_formatting then
            vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
         end
      end,
   }
end

return M

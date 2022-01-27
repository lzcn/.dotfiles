local M = {}

M.setup_lsp = function(attach, capabilities)
   local lsp_installer = require "nvim-lsp-installer"
   
   lsp_installer.settings {
      ui = {
         icons = {
            server_installed = "﫟",
            server_pending = "",
            server_uninstalled = "✗",
         },
      },
   }
   
   lsp_installer.on_server_ready(function(server)
      local opts = {
         on_attach = attach,
         capabilities = capabilities,
         flags = {
            debounce_text_changes = 150,
         },
         settings = {},
         setup = {},
      }
      if server.name == "jsonls" then
         opts.settings = { json = {
      schemas = require("schemastore").json.schemas(),
    },
  }
        opts.setup = {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  }

      end
      if server.name == "sumneko_lua" then
         opts.settings = { 
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
			[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	}
      end
      
      server:setup(opts)
      vim.cmd [[ do User LspAttachBuffers ]]
   end)

end

return M

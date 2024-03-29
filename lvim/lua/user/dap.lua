-- debug adapter protocol
lvim.builtin.dap.active = true
lvim.builtin.dap.breakpoint.text = "●"
lvim.builtin.dap.stopped.text = "▶"

vim.cmd [[highlight DiagnosticSignError guifg=#F44747]]
vim.cmd [[highlight DiagnosticSignWarn guifg=#FFCC00]]

-- support configurations using 'launch.json' file
lvim.builtin.dap.on_config_done = function()
  require("dap.ext.vscode").load_launchjs()
end

local dap, dapui = require "dap", require "dapui"
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

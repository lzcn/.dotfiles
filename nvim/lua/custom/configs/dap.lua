local dap = require('dap')
local dapui = require('dapui')

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpointRed', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStoppedYellow', linehl = '', numhl = '' })

vim.cmd [[highlight DapBreakpointRed guifg=#F44747]]
vim.cmd [[highlight DapStoppedYellow guifg=#FFCC00]]

-- auto open and close dapui
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

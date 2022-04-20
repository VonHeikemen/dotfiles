local doautocmd = require('bridge').doautocmd
local M = {}

vim.cmd([[
  packadd nvim-lsp-installer
  packadd fidget.nvim
  packadd lsp-zero.nvim
]])

local lsp = require('lsp-zero')
local servers = require('lsp.servers')

require('fidget').setup({
  text = {
    spinner = 'moon'
  },
  window = {
    blend = 0
  },
})

lsp.set_preferences({
  setup_servers_on_start = 'per-project',
  set_lsp_keymaps = false
})

lsp.on_attach(function()
  -- only run once per buffer
  if vim.b.lsp_attached == true then return end

  -- keybinding are in lua/conf/keymaps.lua
  doautocmd({'mapping_cmds', 'User', 'LSPKeybindings'})
  vim.b.lsp_attached = true
end)

for server, opts in pairs(servers) do
  lsp.configure(server, opts)
end

M.project_setup = function(opts)
  for server, enable in pairs(opts) do
    if enable == true then
      lsp.use(server, {})
    end
  end
end

-- See :help lsp-zero.use()
M.use = lsp.use

return M


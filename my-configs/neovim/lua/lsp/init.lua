local M = {}

vim.cmd([[
  packadd nvim-lspconfig
  packadd nvim-lsp-installer
  packadd fidget.nvim
  packadd lsp-zero.nvim
]])

local lsp = require('lsp-zero')
local servers = require('lsp.servers')

local augroup = vim.api.nvim_create_augroup('lsp_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local doautocmd = vim.api.nvim_exec_autocmds

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
  cmp_capabilities = true,
  set_lsp_keymaps = false
})

lsp.on_attach(function()
  -- only run once per buffer
  if vim.b.lsp_attached == true then return end

  -- keybindings are in lua/conf/keymaps.lua
  doautocmd('User', {pattern = 'LSPKeybindings', group = 'mapping_cmds'})
  vim.b.lsp_attached = true
end)

for server, opts in pairs(servers) do
  lsp.configure(server, opts)
end

autocmd('ModeChanged', {
  group = augroup,
  pattern = {'n:i', 'v:s'},
  desc = 'Disable diagnostics while typing',
  callback = function() vim.diagnostic.disable(0) end
})

autocmd('ModeChanged', {
  group = augroup,
  pattern = 'i:n',
  desc = 'Enable diagnostics when leaving insert mode',
  callback = function() vim.diagnostic.enable(0) end
})

M.project_setup = function(opts)
  for server, enable in pairs(opts) do
    if enable == true then
      lsp.use(server, {})
    end
  end
end

M.use = lsp.use

return M


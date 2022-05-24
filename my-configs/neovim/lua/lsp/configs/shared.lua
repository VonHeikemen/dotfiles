local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local doautocmd = vim.api.nvim_exec_autocmds
local fmt = string.format

local server_group = 'LSP_server_%s'

M.make_config = function(config)
  local get_server = require('nvim-lsp-installer').get_server

  local defaults = {
    root_dir = vim.fn.getcwd(),
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    on_init = M.on_init,
    on_exit = M.on_exit,
    flags = {
      debounce_text_changes = 150,
    },
  }

  local ok, server = get_server(config.name)
  local server_opts = {}

  if ok then server_opts = server:get_default_options() end

  return vim.tbl_deep_extend(
    'force',
    defaults,
    server_opts,
    config
  )
end

M.on_init = function(client, results)
  if results.offsetEncoding then
    client.offset_encoding = results.offsetEncoding
  end

  if client.config.settings then
    client.notify('workspace/didChangeConfiguration', {
      settings = client.config.settings
    })
  end

  local group = augroup(fmt(server_group, client.id), {clear = true})
  local attach = function()
    require('lsp.client').buf_attach(client.config.filetypes, client.id)
  end

  autocmd('BufEnter', {
    pattern = '*',
    group = group,
    desc = fmt('Attach LSP: %s', client.name),
    callback = attach
  })

  if vim.v.vim_did_enter == 1 then
    attach()
  end
end

M.on_exit = function(code, signal, client_id)
  vim.schedule(function()
    vim.api.nvim_del_augroup_by_name(fmt(server_group, client_id))
  end)
end

M.on_attach = function(client, bufnr)
  if vim.b.lsp_attached then return  end
  vim.b.lsp_attached = true

  -- keybindings are in lua/conf/keymaps.lua
  doautocmd('User', {pattern = 'LSPKeybindings', group = 'mapping_cmds'})
end

M.capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

return M

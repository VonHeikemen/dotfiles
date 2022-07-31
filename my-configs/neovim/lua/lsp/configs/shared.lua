local M = {}

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local doautocmd = vim.api.nvim_exec_autocmds
local fmt = string.format

local server_group = 'LSP_server_%s'

function M.make_config(config)
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

  return vim.tbl_deep_extend(
    'force',
    defaults,
    config
  )
end

function M.on_init(client, results)
  if results.offsetEncoding then
    client.offset_encoding = results.offsetEncoding
  end

  if client.config.settings then
    client.notify('workspace/didChangeConfiguration', {
      settings = client.config.settings
    })
  end

  local group = augroup(fmt(server_group, client.id), {clear = true})
  local filetypes = client.config.filetypes or {'*'}

  local attach = function()
    vim.lsp.buf_attach_client(0, client.id)
  end

  autocmd('FileType', {
    pattern = filetypes,
    group = group,
    desc = fmt('Attach LSP: %s', client.name),
    callback = attach
  })

  if vim.v.vim_did_enter == 0 then return end

  if filetypes[1] == '*' or vim.tbl_contains(filetypes, vim.bo.filetype) then
    attach()
  end
end

M.on_exit = vim.schedule_wrap(function(code, signal, client_id)
  local group = fmt(server_group, client_id)

  if vim.fn.exists(fmt('#%s', group)) == 1 then
    vim.api.nvim_del_augroup_by_name(group)
  end
end)

function M.on_attach(client, bufnr)
  if vim.b.lsp_attached then return  end
  vim.b.lsp_attached = true

  local bufcmd = vim.api.nvim_buf_create_user_command
  vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
  vim.bo.tagfunc = 'v:lua.vim.lsp.tagfunc'

  bufcmd(bufnr, 'LspFormat', M.format_cmd, {
    bang = true,
    range = true,
    desc = 'LSP based formatting'
  })

  -- keybindings are in lua/user/keymaps.lua
  doautocmd('User', {pattern = 'LspAttached'})
end

M.capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

function M.format_cmd(input)
  local has_range = input.line2 == input.count
  local execute = vim.lsp.buf.formatting

  if input.bang then
    if has_range then return end
    execute = vim.lsp.buf.formatting_sync
  end

  if has_range then
    execute = vim.lsp.buf.range_formatting
  end

  execute()
end

return M


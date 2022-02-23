vim.cmd([[
  packadd nvim-lspconfig
  packadd nvim-lsp-installer
  packadd fidget.nvim
]])

local M = {}
local s = {}

s.fidget_opts = {
  text = {
    spinner = 'moon'
  },
  window = {
    blend = 0
  }
}

local servers = require('lsp.servers')
local get_server = require('nvim-lsp-installer.servers').get_server
local lspconfig = require('lspconfig')

M.setup = function(server_name, user_opts)
  user_opts = user_opts or {}

  local ok, server = get_server(server_name)

  if not ok then return end

  s.call_once()

  local common = servers[server_name] or {}
  local opts = vim.tbl_deep_extend('force', {}, common, user_opts)

  if opts.root_dir == true then
    opts.root_dir = function() return vim.fn.getcwd() end
  end

  opts.on_attach = function(...)
    s.on_attach(...)
    if common.on_attach then common.on_attach(...) end
    if user_opts.on_attach then user_opts.on_attach(...) end
  end

  server:setup_lsp(opts)
  lspconfig[server.name].manager.try_add_wrapper()
end

s.call_once = function()
  require('fidget').setup(s.fidget_opts)

  s.diagnostics()

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {
      border = 'rounded',
    }
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
      border = 'rounded',
    }
  )

  local fmt = string.format
  local command = function(name, str)
    vim.cmd(fmt('command! %s lua %s', name, str))
  end

  command('LspWorkspaceAdd', 'vim.lsp.buf.add_workspace_folder()')
  command('LspWorkspaceList', 'vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))')

  s.call_once = function() end
end

s.on_attach = function(_, bufnr)
  s.set_keymaps(bufnr)

  local fmt = string.format
  local command = function(name, str)
    vim.cmd(fmt('command! -buffer %s lua %s', name, str))
  end

  command('LspFormat', 'vim.lsp.buf.formatting()')
  command('LspWorkspaceRemove', 'vim.lsp.buf.remove_workspace_folder()')
end

s.diagnostics = function()
  local sign = function(opts)
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = ''
    })
  end

  sign({name = 'DiagnosticSignError', text = '✘'})
  sign({name = 'DiagnosticSignWarn', text = '▲'})
  sign({name = 'DiagnosticSignHint', text = '⚑'})
  sign({name = 'DiagnosticSignInfo', text = ''})

  vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  })
end

s.set_keymaps = function(bufnr)
  local fmt = function(cmd) return function(str) return cmd:format(str) end end

  local map = function(m, lhs, rhs)
    local opts = {noremap = true, silent = true}
    vim.api.nvim_buf_set_keymap(bufnr, m, lhs, rhs, opts)
  end

  local lsp = fmt('<cmd>lua vim.lsp.%s<cr>')
  local diagnostic = fmt('<cmd>lua vim.diagnostic.%s<cr>')
  local telescope = fmt('<cmd>lua require("telescope.builtin").%s<cr>')

  map('n', '<leader>fi', '<cmd>LspInfo<cr>')

  map('n', 'K', lsp 'buf.hover()')
  map('n', 'gd', lsp 'buf.definition()')
  map('n', 'gD', lsp 'buf.declaration()')
  map('n', 'gi', lsp 'buf.implementation()')
  map('n', 'go', lsp 'buf.type_definition()')
  map('n', 'gr', lsp 'buf.references()')
  map('n', 'gs', lsp 'buf.signature_help()')
  map('n', '<F3>', lsp 'buf.rename()')
  map('n', '<F5>', lsp 'buf.code_action()')

  map('i', '<M-i>', lsp 'buf.signature_help()')

  map('n', 'gl', diagnostic 'open_float()')
  map('n', '[d', diagnostic 'goto_prev()')
  map('n', ']d', diagnostic 'goto_next()')

  map('n', '<leader>fd', telescope 'lsp_document_symbols()')
  map('n', '<leader>fq', telescope 'lsp_workspace_symbols()')
  map('n', '<leader>fa', telescope 'lsp_code_actions()')
end

M.setup_all = function()
  for name, _ in pairs(servers) do
    M.setup(name)
  end
end

M.setup_servers = function(list)
  local opts = list.opts
  local here = list.root_dir == true

  if opts == nil and here then
    opts = {root_dir = true}
  end

  for _, server in pairs(list) do
    M.setup(server, opts)
  end
end

return M


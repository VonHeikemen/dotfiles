vim.cmd([[
  packadd nvim-lspconfig
  packadd nvim-lsp-installer
  packadd fidget.nvim
]])

local M = {}
local s = {}

local state = {
  global_cmds = false,
  fidget_loaded = false
}

s.fidget_opts = {
  window = {
    blend = 0
  }
}

local servers = require('lsp.servers')
local get_server = require('nvim-lsp-installer.servers').get_server

M.setup = function(server_name, user_opts)
  user_opts = user_opts or {}

  local ok, server = get_server(server_name)

  if not ok then return end

  if not state.fidget_loaded then
    require('fidget').setup(s.fidget_opts)
    state.fidget_loaded = true
  end

  local common = servers[server_name] or {}
  local opts = vim.tbl_deep_extend('force', {}, common, user_opts)

  if opts.here then
    opts.root_dir = function() return vim.fn.getcwd() end
    opts.here = nil
  end

  opts.on_attach = function(...)
    s.on_attach(...)
    if common.on_attach then common.on_attach(...) end
    if user_opts.on_attach then user_opts.on_attach(...) end
  end

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

  s.diagnostics()

  server:setup(opts)
end

s.on_attach = function(_, bufnr)
  s.set_keymaps(bufnr)

  local fmt = string.format
  local command = function(name, str, attr)
    attr = attr or ''
    vim.cmd(fmt('command! %s %s lua %s', attr, name, str))
  end

  command('LspFormat', 'vim.lsp.buf.formatting()', '-buffer')
  command('LspWorkspaceRemove', 'vim.lsp.buf.remove_workspace_folder()', '-buffer')

  if not state.global_cmds then
    command('LspWorkspaceAdd', 'vim.lsp.buf.add_workspace_folder()')
    command('LspWorkspaceList', 'vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))')
    state.global_cmds = false
  end
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

  map('n', 'qi', '<cmd>LspInfo<cr>')

  map('n', 'K', lsp 'buf.hover()')
  map('n', 'gd', lsp 'buf.definition()')
  map('n', 'gD', lsp 'buf.declaration()')
  map('n', 'gi', lsp 'buf.implementation()')
  map('n', 'go', lsp 'buf.type_definition()')
  map('n', 'gr', lsp 'buf.references()')
  map('n', 'qs', lsp 'buf.signature_help()')
  map('n', 'qc', lsp 'buf.rename()')
  map('n', 'qa', lsp 'buf.code_action()')

  map('i', '<M-i>', lsp 'buf.signature_help()')

  map('n', 'qd', diagnostic 'open_float()')
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

return M


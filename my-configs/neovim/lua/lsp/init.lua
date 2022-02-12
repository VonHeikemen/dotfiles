vim.cmd([[
  packadd nvim-lspconfig
  packadd nvim-lsp-installer
  packadd fidget.nvim
]])

local M = {}
local s = {}
local server = require('lsp.servers')
local get_server = require('nvim-lsp-installer.servers').get_server

M.setup = function(server_name, user_opts)
  user_opts = user_opts or {}

  local ok, server = get_server(server_name)

  if not ok then return end

  if not s.fidget then
    require('fidget').setup(s.fidget_opts)
    s.fidget = true
  end

  local common = server[server_name] or {}
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

s.on_attach = function(client, bufnr)
  local fmt = string.format

  local nmap = function(lhs, rhs)
    local opts = {noremap = true, silent = true}
    vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, opts)
  end

  local lsp = function(str) return fmt('<cmd>lua vim.lsp.%s<cr>', str) end
  local diagnostic = function(str) return fmt('<cmd>lua vim.diagnostic.%s<cr>', str) end
  local telescope = function(str) return fmt('<cmd>lua require("telescope.builtin").%s<cr>', str) end
  local command = function(name, str) vim.cmd(fmt('command! -buffer %s lua %s', name, str)) end

  nmap('K', lsp 'buf.hover()')
  nmap('gd', lsp 'buf.definition()')
  nmap('gD', lsp 'buf.declaration()')
  nmap('gi', lsp 'buf.implementation()')
  nmap('go', lsp 'buf.type_definition()')
  nmap('gr', lsp 'buf.references()')
  nmap(';s', lsp 'buf.signature_help()')
  nmap(';c', lsp 'buf.rename()')

  nmap(';d', diagnostic 'open_float()')
  nmap('[d', diagnostic 'goto_prev()')
  nmap(']d', diagnostic 'goto_next()')

  nmap('<leader>fd', telescope 'lsp_document_symbols()')
  nmap('<leader>fq', telescope 'lsp_workspace_symbols()')
  nmap('<leader>fa', telescope 'lsp_code_actions()')

  command('LspFormat', 'vim.lsp.buf.formatting()')
  command('LspWorkspaceAdd', 'vim.lsp.buf.add_workspace_folder()')
  command('LspWorkspaceRemove', 'vim.lsp.buf.remove_workspace_folder()')
  command('LspWorkspaceList', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')
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
    update_in_insert = true,
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

s.fidget = false
s.fidget_opts = {
  window = {
    blend = 0
  }
}

return M


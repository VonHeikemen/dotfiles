local M = {}

vim.cmd([[
  packadd fidget.nvim
  packadd mason.nvim
]])

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

local lsp = require('lsp.client')

require('mason').setup({
  ui = {border = 'rounded'}
})

require('fidget').setup({
  text = {
    spinner = 'moon'
  },
  window = {
    blend = 0
  },
  sources = {
    ['null-ls'] = {ignore = true}
  }
})

function M.diagnostics()
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

  local group = augroup('diagnostic_cmds', {clear = true})

  autocmd('ModeChanged', {
    group = group,
    pattern = {'n:i', 'v:s'},
    desc = 'Disable diagnostics while typing',
    callback = function() vim.diagnostic.disable(0) end
  })

  autocmd('ModeChanged', {
    group = group,
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function() vim.diagnostic.enable(0) end
  })
end

function M.handlers()
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = 'rounded'}
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = 'rounded'}
  )
end

function M.project_setup(opts)
  for server, enable in pairs(opts) do
    if enable == true then
      lsp.start(server)
    end
  end
end

M.start = lsp.start

M.diagnostics()
M.handlers()

return M


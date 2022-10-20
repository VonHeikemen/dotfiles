local M = {}

vim.cmd([[
  packadd fidget.nvim
  packadd nvim-lspconfig
  packadd mason.nvim
  packadd mason-lspconfig.nvim
]])

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

require('mason').setup({
  ui = {border = 'rounded'}
})

require('mason-lspconfig').setup({})

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
      numhl = '',
    })
  end

  sign({name = 'DiagnosticSignError', text = '✘'})
  sign({name = 'DiagnosticSignWarn', text = '▲'})
  sign({name = 'DiagnosticSignHint', text = '⚑'})
  sign({name = 'DiagnosticSignInfo', text = '»'})

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
      M.start(server, {})
    end
  end
end

function M.start(name, opts)
  opts = opts or {}

  opts.single_file_support = false
  opts.capabilities = require('cmp_nvim_lsp').default_capabilities()

  if opts.root_dir == nil then
    opts.root_dir = function() return vim.fn.getcwd() end
  end

  local defaults = require('lsp.servers').get(name)
  local lsp = require('lspconfig')[name]

  lsp.setup(vim.tbl_deep_extend('force', defaults, opts))

  if vim.v.vim_did_enter == 1 and lsp.manager then
    lsp.manager.try_add_wrapper()
  end
end

M.diagnostics()
M.handlers()

return M


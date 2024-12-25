-- LSP support
local Plugin = {'neovim/nvim-lspconfig'}
local user = {}

Plugin.dependencies = {
  {'hrsh7th/cmp-nvim-lsp'},
  {'williamboman/mason-lspconfig.nvim'},
  {'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
}

Plugin.cmd = 'Lsp'

function Plugin.config()
  require('user.diagnostics')

  user.lspconfig()
  user.float_border('rounded')

  require('mason-lspconfig').setup({})

  vim.api.nvim_create_user_command(
    'Lsp',
    function(input)
      if input.args == '' then
        return
      end

      require('lsp-zero').use(input.args, {})
    end,
    {desc = 'Initialize a language server', nargs = '?'}
  )
end

function user.lspconfig()
  local lsp = require('lsp-zero')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  lsp.extend_lspconfig({
    lsp_attach = user.lsp_attach,
    capabilities = capabilities,
  })

  lsp.client_config({
    single_file_support = false,
    root_dir = function()
      return vim.fn.getcwd()
    end,
  })

  local configs = require('lspconfig.configs')

  configs.nvim_lua = {
    default_config = lsp.nvim_lua_ls({
      cmd = {'lua-language-server'},
      filetypes = {'lua'},
    })
  }
end

function user.lsp_attach(client, bufnr)
  -- Disable semantic highlights
  client.server_capabilities.semanticTokensProvider = nil
end

function user.float_border(style)
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = style}
  ) 
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = style}
  )
end

return Plugin


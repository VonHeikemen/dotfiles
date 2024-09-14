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

  local bind = vim.keymap.set
  local opts = {silent = true, buffer = bufnr}

  bind({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

  bind('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  bind('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  bind('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  bind('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  bind('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  bind('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  bind('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  bind('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  bind('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

  bind('n', '<leader>fd', '<cmd>Telescope lsp_document_symbols<cr>', opts)
  bind('n', '<leader>fq', '<cmd>Telescope lsp_workspace_symbols<cr>', opts)
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


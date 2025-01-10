-- LSP support
local Plugin = {'neovim/nvim-lspconfig'}
Plugin.depends = {
  'hrsh7th/cmp-nvim-lsp',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  {'VonHeikemen/lsp-zero.nvim', rev = 'v4.x'},
}

Plugin.cmd = {'LspConfig'}
Plugin.user_event = {'lspconfig'}

local user = {}

function Plugin.config()
  vim.cmd('SpecEvent mason')
  require('user.lsp')

  user.lspconfig()
  require('mason-lspconfig').setup({})

  vim.api.nvim_create_user_command(
    'LspConfig',
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
  lsp.extend_lspconfig({capabilities = capabilities})

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

return Plugin


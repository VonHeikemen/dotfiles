-- LSP support
local Plugin = {'neovim/nvim-lspconfig'}
local user = {}

Plugin.dependencies = {
  {'hrsh7th/cmp-nvim-lsp'},
  {'williamboman/mason-lspconfig.nvim'},
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
}

Plugin.cmd = 'Lsp'

function Plugin.init()
  vim.g.lsp_zero_extend_cmp = 0
  vim.g.lsp_zero_extend_lspconfig = 0
end

function Plugin.config()
  user.lspconfig()
  user.diagnostics()

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

  lsp.extend_lspconfig()

  lsp.on_attach(user.lsp_attach)

  lsp.set_server_config({
    single_file_support = false,
    root_dir = function()
      return vim.fn.getcwd()
    end,
  })

  lsp.store_config('tsserver', {
    settings = {
      completions = {
        completeFunctionCalls = true
      }
    }
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
  local telescope = require('telescope.builtin')
  local bind = vim.keymap.set
  local command = vim.api.nvim_buf_create_user_command

  -- Disable semantic highlights
  client.server_capabilities.semanticTokensProvider = nil

  command(bufnr, 'LspFormat', function(input)
    vim.lsp.buf.format({async = input.bang})
  end, {})

  local opts = {silent = true, buffer = bufnr}

  bind({'n', 'x'}, 'gq', '<cmd>LspFormat!<cr>', opts)

  bind('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  bind('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  bind('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  bind('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  bind('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  bind('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  bind('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  bind('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  bind('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

  bind('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  bind('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
  bind('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)

  bind('n', '<leader>fd', telescope.lsp_document_symbols, opts)
  bind('n', '<leader>fq', telescope.lsp_workspace_symbols, opts)
end

function user.diagnostics()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd
  local level = vim.diagnostic.severity

  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = {
        [level.ERROR] = '✘',
        [level.WARN] = '▲',
        [level.HINT] = '⚑',
        [level.INFO] = '»',
      }
    }
  })

  local group = augroup('diagnostic_cmds', {clear = true})

  autocmd('ModeChanged', {
    group = group,
    pattern = {'n:i', 'v:s'},
    desc = 'Disable diagnostics while typing',
    callback = function(e) vim.diagnostic.enable(false, {bufnr = e.buf}) end
  })

  autocmd('ModeChanged', {
    group = group,
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function(e) vim.diagnostic.enable(true, {bufnr = e.buf}) end
  })
end

return Plugin


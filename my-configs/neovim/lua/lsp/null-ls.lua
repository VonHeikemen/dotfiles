local M = {}
vim.cmd('packadd null-ls.nvim')

local null_ls = require('null-ls')
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local config = {
  on_attach = function(client, bufnr)
    local bufcmd = vim.api.nvim_buf_create_user_command
    local format = function()
      local params = vim.lsp.util.make_formatting_params({})
      client.request('textDocument/formatting', params, nil, bufnr)
    end

    if client.server_capabilities.documentFormattingProvider then
      bufcmd(bufnr, 'NullFormat', format, {desc = 'Format using null-ls'})
    end

    require('lsp.configs.shared').on_attach(client, bufnr)
  end,
  sources = {
    formatting.prettier,
    diagnostics.php
  }
}

M.setup = function()
  require('lsp')
  null_ls.setup(config)
end

return M


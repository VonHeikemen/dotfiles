local M = {}
vim.cmd('packadd null-ls.nvim')

local null_ls = require('null-ls')

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local config = {
  on_attach = function(client, bufnr)
    local bufcmd = vim.api.nvim_buf_create_user_command
    local format_cmd = function(input)
      require('lsp.client').format_cmd(input, client, bufnr)
    end

    bufcmd(bufnr, 'NullFormat', format_cmd, {
      bang = true,
      range = true,
      desc = 'Format using null-ls'
    })

    require('lsp.config').on_attach(client, bufnr)

    vim.keymap.set({'n', 'x'}, '<leader>;', '<cmd>NullFormat<cr>', {
      buffer = bufnr
    })
  end,
  sources = {
    formatting.prettier,
    diagnostics.php
  }
}

function M.setup()
  require('lsp')
  null_ls.setup(config)
end

return M


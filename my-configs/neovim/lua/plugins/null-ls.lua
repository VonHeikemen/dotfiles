local Plugin = {'jose-elias-alvarez/null-ls.nvim'}

Plugin.dependencies = {{'nvim-lua/plenary.nvim'}}

Plugin.cmd = 'NullLsp'

function Plugin.config()
  local null_ls = require('null-ls')

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  local config = {
    on_attach = function(client, bufnr)
      local bufcmd = vim.api.nvim_buf_create_user_command
      local format_cmd = function(input)
        vim.lsp.buf.format({
          id = client.id,
          timeout_ms = 5000,
          async = input.bang,
        })
      end

      bufcmd(bufnr, 'NullFormat', format_cmd, {
        bang = true,
        range = true,
        desc = 'Format using null-ls'
      })

      vim.keymap.set({'n', 'x'}, 'gq', '<cmd>NullFormat!<cr>', {
        buffer = bufnr
      })
    end,
    sources = {
      formatting.prettier.with({
        prefer_local = 'node_modules/.bin',
      }),
      diagnostics.php
    }
  }

  vim.api.nvim_create_user_command(
    'NullLsp',
    function()
      null_ls.setup(config)
    end,
    {desc = 'Initialize Null-ls'}
  )
end

return Plugin


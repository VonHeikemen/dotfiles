local Plugin = {'stevearc/quicker.nvim'}

Plugin.opts = {
  highlight = {
    lsp = false,
    treesitter = true,
  },
  keys = {
    {'<leader>uc', '<cmd>QflExpand<cr>'},
  },
}

function Plugin.config(opts)
  local quicker = require('quicker')
  local command = vim.api.nvim_create_user_command

  quicker.setup(opts)

  command('QflExpand', function()
    quicker.toggle_expand()
  end, {})
end

return Plugin


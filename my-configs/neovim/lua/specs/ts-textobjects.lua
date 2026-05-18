local Plugin = {'nvim-treesitter/nvim-treesitter-textobjects'}
local user = {}

Plugin.rev = 'main'

function Plugin.config()
  vim.keymap.set('n', 'sif', [[vif<Esc>/\%V\V]], {remap = true})

  user.textobject('af', '@function.outer')
  user.textobject('if', '@function.inner')
  user.textobject('ac', '@class.outer')
  user.textobject('ic', '@class.inner')
end

function user.textobject(lhs, ts_capture)
  vim.keymap.set({'x', 'o'}, lhs, function()
    require('nvim-treesitter-textobjects.select')
      .select_textobject(ts_capture, 'textobjects')
  end)
end

return Plugin


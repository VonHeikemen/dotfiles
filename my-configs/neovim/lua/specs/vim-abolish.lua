local Plugin = {'tpope/vim-abolish'}

Plugin.keys = {'st'}

function Plugin.init()
  vim.g.abolish_no_mappings = 1
end

function Plugin.config()
  vim.keymap.set('n', 'st', '<Plug>(abolish-coerce-word)')
end

return Plugin


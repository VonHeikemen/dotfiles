-- Work with variants of a word
local Plugin = {'tpope/vim-abolish'}

Plugin.user_event = {'SpecVimEdit'}

function Plugin.init()
  vim.g.abolish_no_mappings = 1
end

function Plugin.config()
  vim.keymap.set('n', 'st', '<Plug>(abolish-coerce-word)')
end

return Plugin


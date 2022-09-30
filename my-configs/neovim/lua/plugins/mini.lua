local bind = vim.keymap.set

require('mini.ai').setup({})
require('mini.bufremove').setup({})

require('mini.surround').setup({
  search_method = 'cover',
  mappings = {
    add = '',
    delete = 'ds',
    replace = 'cs',
    find = '',
    find_left = '',
    highlight = '',
    update_n_lines = '',
  },
})

-- Close buffer while preserving the layout
bind('n', '<Leader>bc', '<cmd>lua MiniBufremove.delete()<cr>')

-- Add surroundings
bind('x', 'Y', ":<C-u>lua MiniSurround.add('visual')<cr>")
bind('n', 'ys', "v:lua.MiniSurround.operator('add')", {expr = true})


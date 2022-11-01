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

-- Add surroundings
vim.keymap.set('x', 'Y', ":<C-u>lua MiniSurround.add('visual')<cr>")
vim.keymap.set('n', 'ys', "v:lua.MiniSurround.operator('add')", {expr = true})


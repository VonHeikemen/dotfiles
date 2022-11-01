require('mini.bufremove').setup({})

-- Close buffer while preserving the layout
vim.keymap.set('n', '<Leader>bc', '<cmd>lua MiniBufremove.delete()<cr>')


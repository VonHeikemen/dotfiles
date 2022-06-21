require('leap').setup({
  safe_labels = {},
  labels = {
    'w', 'f', 'a',
    'j', 'k', 'l', 'o', 'i', 'q', 'e', 'h', 'g',
    'u', 't',
    'm', 'v', 'c', 'n', '.', 'z',
    '/', 'F', 'L', 'N', 'H', 'G', 'M', 'U', 'T', '?', 'Z',
  },
})

local bind = vim.keymap.set

bind({'n', 'x', 'o'}, 'w', '<Plug>(leap-forward)')
bind({'n', 'x', 'o'}, 'b', '<Plug>(leap-backward)')

bind({'n', 'x', 'o'}, 'L', 'w')
bind({'n', 'x', 'o'}, 'H', 'b')


require('indent_blankline').setup({
  enabled = false,
  char = '▏',
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = true,
  show_current_context = false
})

vim.keymap.set('n', '<leader>ui', '<cmd>IndentBlanklineToggle<cr>')


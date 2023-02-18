-- Indent guides
local Plugin = {'lukas-reineke/indent-blankline.nvim'}

Plugin.name = 'indent_blankline'

Plugin.opts = {
  enabled = false,
  char = '▏',
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = true,
  show_current_context = false
}

Plugin.keys = {
  {'<leader>ui', '<cmd>IndentBlanklineToggle<cr>'}
}

return Plugin


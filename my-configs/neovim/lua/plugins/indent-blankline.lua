-- Indent guides
local Plugin = {'lukas-reineke/indent-blankline.nvim'}

Plugin.name = 'indent_blankline'

Plugin.event = {'BufReadPost', 'BufNewFile'}

Plugin.opts = {
  enabled = false,
  char = '▏',
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  use_treesitter = true,
  show_current_context = false
}

function Plugin.init()
  vim.keymap.set('n', '<leader>ui', '<cmd>IndentBlanklineToggle<cr>')
end

return Plugin


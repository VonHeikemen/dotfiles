-- Buffer search prompt
local Plugin = {'VonHeikemen/searchbox.nvim'}

Plugin.dependencies = {{'MunifTanjim/nui.nvim'}}

Plugin.name = 'searchbox'

Plugin.opts = {
  defaults = {
    modifier = 'plain',
    confirm = 'native',
    show_matches = '[T:{total}]'
  }
}

Plugin.cmd = {
  'SearchBoxIncSearch',
  'SearchBoxMatchAll',
  'SearchBoxReplace'
}

function Plugin.init()
  local bind = vim.keymap.set

  bind('n', 's', ':SearchBoxIncSearch<CR>')
  bind('x', 's', ':SearchBoxIncSearch visual_mode=true<CR>')
  bind('n', 'S', ":SearchBoxMatchAll title=' Match '<CR>")
  bind('x', 'S', ":SearchBoxMatchAll title=' Match ' visual_mode=true<CR>")
  bind('n', '<leader>s', '<cmd>SearchBoxClear<CR>')

  bind('n', 'r', ":SearchBoxReplace<CR>")
  bind('x', 'r', ":SearchBoxReplace visual_mode=true<CR>")
  bind('n', 'R', ":SearchBoxReplace -- <C-r>=expand('<cword>')<CR><CR>")
  bind('x', 'R', ":<C-u>GetSelection<CR>:SearchBoxReplace<CR><C-r>/")
end

return Plugin


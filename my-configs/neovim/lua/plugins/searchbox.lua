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

  bind('n', 'si', '<cmd>SearchBoxIncSearch<cr>')
  bind('x', 'si', "<Esc><cmd>'<,'>SearchBoxIncSearch visual_mode=true<cr>")
  bind('n', 'sj', "<cmd>SearchBoxMatchAll title=' Match '<cr>")
  bind('x', 'sj', "<Esc><cmd>'<,'>SearchBoxMatchAll title=' Match ' visual_mode=true<cr>")
  bind('n', '<leader>s', '<cmd>SearchBoxClear<cr>')

  bind('n', 'r', "<cmd>SearchBoxReplace <CR>")
  bind('x', 'r', "<Esc><cmd>SearchBoxReplace  visual_mode=true<cr>")
  bind('n', 'R', "<cmd>exe 'SearchBoxReplace  --' expand('<cword>')<cr>")
  bind('x', 'R', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxReplace --' getreg('/')<cr>")
end

return Plugin


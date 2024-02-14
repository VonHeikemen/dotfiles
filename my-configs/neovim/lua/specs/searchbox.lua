-- Buffer search prompt
local Plugin = {'VonHeikemen/searchbox.nvim'}

Plugin.dependencies = {{'MunifTanjim/nui.nvim'}}

Plugin.opts = {
  defaults = {
    modifier = 'plain',
    confirm = 'native',
    show_matches = '[T:{total}]'
  },
}

Plugin.cmd = {
  'SearchBoxIncSearch',
  'SearchBoxMatchAll',
  'SearchBoxReplace'
}

function Plugin.init()
  local bind = vim.keymap.set

  bind('n', 's', '<nop>')

  bind('n', 'si', '<cmd>SearchBoxIncSearch<cr>')
  bind('x', 'si', "<Esc><cmd>'<,'>SearchBoxIncSearch visual_mode=true<cr>")
  bind('n', 'sw', "<cmd>exe 'SearchBoxIncSearch  --' expand('<cword>')<cr>")
  bind('x', 'sw', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxIncSearch --' getreg('/')<cr>")

  bind('n', 'sm', '<cmd>SearchBoxMatchAll<cr>')
  bind('x', 'sm', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxMatchAll --' getreg('/')<cr>")

  bind('n', 'sc', '<cmd>SearchBoxReplace <CR>')
  bind('x', 'sc', '<Esc><cmd>SearchBoxReplace  visual_mode=true<cr>')
  bind('n', 'sC', "<cmd>exe 'SearchBoxReplace  --' expand('<cword>')<cr>")
  bind('x', 'sC', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxReplace --' getreg('/')<cr>")
end

return Plugin


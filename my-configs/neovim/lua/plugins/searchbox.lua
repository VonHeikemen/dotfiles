local bind = vim.keymap.set

require('searchbox').setup({
  defaults = {
    modifier = 'plain',
    confirm = 'menu',
  }
})

bind('n', 's', ':SearchBoxIncSearch<CR>')
bind('x', 's', ':SearchBoxIncSearch visual_mode=true<CR>')
bind('n', 'S', ":SearchBoxMatchAll title=' Match '<CR>")
bind('x', 'S', ":SearchBoxMatchAll title=' Match ' visual_mode=true<CR>")
bind('n', '<leader>s', '<cmd>SearchBoxClear<CR>')

bind('n', 'r', ":SearchBoxReplace confirm=menu<CR>")
bind('x', 'r', ":SearchBoxReplace confirm=menu visual_mode=true<CR>")
bind('n', 'R', ":SearchBoxReplace confirm=menu -- <C-r>=expand('<cword>')<CR><CR>")
bind('x', 'R', ":<C-u>GetSelection<CR>:SearchBoxReplace confirm=menu<CR><C-r>/")


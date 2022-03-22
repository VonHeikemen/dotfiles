require('zen-mode').setup({
  window = {
    width = 0.60,
    height = 0.98
  },
  on_open = function(win)
    local bufmap = function(mode, lhs, rhs)
      vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, {noremap = true})
    end
    vim.opt.wrap = true
    vim.opt.linebreak = true

    bufmap('n', 'k', 'gk')
    bufmap('n', 'j', 'gj')
    bufmap('x', 'k', 'gk')
    bufmap('x', 'j', 'gj')
    bufmap('n', 'O', 'O<Enter><Up>')
  end
})


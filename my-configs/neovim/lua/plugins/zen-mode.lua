require('zen-mode').setup({
  zindex = 11,
  window = {
    width = 0.60,
    height = 0.98
  },
  on_open = function(win)
    local bind = function(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, {buffer = true})
    end

    vim.opt.wrap = true
    vim.opt.linebreak = true

    bind('n', 'k', 'gk')
    bind('n', 'j', 'gj')
    bind('x', 'k', 'gk')
    bind('x', 'j', 'gj')
    bind('n', 'O', 'O<Enter><Up>')
  end
})


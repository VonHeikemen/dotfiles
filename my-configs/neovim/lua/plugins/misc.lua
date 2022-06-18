local M = {}

M.autopairs = function()
  local npairs = require('nvim-autopairs')
  npairs.setup({fast_wrap = {}})
end

M.kommentary = function()
  local cfg = require('kommentary.config')

  cfg.configure_language('default', {
    prefer_single_line_comments = true,
  })
  cfg.configure_language('php', {
    single_line_comment_string = '//'
  })
  cfg.configure_language('python', {
    single_line_comment_string = '#'
  })
end

M.fine_cmdline = function()
  require('fine-cmdline').setup({
    cmdline = {
      prompt = ' '
    }
  })
end

M.searchbox = function()
  require('searchbox').setup({
    hooks = {
      on_done = function(value)
        if value == nil then return end
        vim.fn.setreg('s', value)
      end
    }
  })
end

M.nvim_notify = function()
  vim.notify = require('notify')
  vim.notify.setup({
    stages = 'slide',
    level = 'DEBUG',
    background_colour = vim.g.terminal_color_background,
    minimum_width = 15
  })
end

M.guess_indent = function()
  require('guess-indent').setup({
    auto_cmd = false,
    verbose = 1
  })
end

M.leap = function()
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
end

M.neogit = function()
  vim.cmd('packadd diffview.nvim')

  require('diffview').setup({
    use_icons = false
  })

  require('neogit').setup({
    disable_hint = true,
    auto_refresh = false,
    integrations = {diffview = true},
    signs = {
      section = {'»', '-'},
      item = {'+', '*'}
    },
    mappings = {
      status = {
        [';'] = 'RefreshBuffer'
      }
    }
  })

  vim.keymap.set('n', '<leader>g', '<cmd>Neogit<cr>')
end

M.indent_blankline = function()
  require('indent_blankline').setup({
    enabled = false,
    char = '▏',
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = false
  })
end

return M


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

M.lightspeed = function()
  require('lightspeed').setup({
    limit_ft_matches = 0,
    jump_to_unique_chars = false,
    exit_after_idle_msecs = {labeled = nil, unlabeled = 600},
    safe_labels = {},
    labels = {
      'w', 'f', 'a',
      'j', 'k', 'l', 'o', 'i', 'q', 'e', 'h', 'g',
      'u', 't',
      'm', 'v', 'c', 'n', '.', 'z',
      '/', 'F', 'L', 'N', 'H', 'G', 'M', 'U', 'T', '?', 'Z',
    },
  })
end

return M


local M = {}

M.zen_mode = function()
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
end

M.luasnip = function()
  local luasnip = require('luasnip')
  local snippets = require('luasnip.loaders.from_vscode')

  luasnip.config.set_config({
    history = false,
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
  })

  snippets.lazy_load()
  local filetype = vim.bo.filetype

  if vim.fn.argc() > 0 and filetype ~= '' then
    snippets.load({include = {filetype}})
  end
end

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


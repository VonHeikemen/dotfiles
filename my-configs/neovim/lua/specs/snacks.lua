-- A collection of small QoL plugins
local Plugin = {'folke/snacks.nvim'}

local user = {}
local small_screen = vim.g.env_small_screen or 17

Plugin.lazy = false

function Plugin.opts()
  return {
    bigfile = {
      enabled = true,
      notify = true,
    },
    scratch = {
      ft = 'markdown',
      filekey = {
        branch = false,
      },
      win = {
        width = 0.7,
        height = 0.7,
      },
    },
    indent = {
      enabled = false,
      char = '▏',
    },
    scope = {
      enabled = true,
    },
    animate = {
      enabled = false,
    },
    terminal = {
      win = {
        bo = {filetype = 'term'},
      },
    },
    toggle = {
      notify = false,
    },
    dashboard = {
      enabled = true,
      formats = {
        header = {'%s', align = 'center', hl = 'String'},
      },
      preset = {
        header = 'NEOVIM',
        keys = user.dashboard_actions(),
      },
      sections = {
        {section = 'header'},
        {section = 'keys', gap = 1, padding = 1},
        user.nvim_version(),
      },
    },
  }
end

function Plugin.config(_, opts)
  local Snacks = require('snacks')
  Snacks.setup(opts)

  Snacks.toggle.indent():map('<leader>ui')

  vim.keymap.set('n', '<leader>db', function()
    local env = {DELTA_FEATURES = 'min'}
    Snacks.git.blame_line({env = env})
  end, {desc = 'Git blame line'})

  vim.keymap.set('n', '<leader>bc', function()
    Snacks.bufdelete()
  end, {desc = 'Close buffer'})

  vim.keymap.set('n', '<leader>ds', function()
    Snacks.scratch()
  end, {desc = 'Open notes'})

  user.snack_terminal()
end

function user.snack_terminal()
  local Snacks = require('snacks')
  local command = vim.api.nvim_create_user_command

  vim.keymap.set({'n', 'i', 'x', 't'}, '<M-i>', '<cmd>ToggleShell<cr>')
  vim.keymap.set('n', '<leader>g', '<cmd>GitStatus<cr>')

  local toggle_shell = function()
    local window = {
      position = 'top',
      height = 0.3,
      wo = {winbar = ''},
    }

    if vim.o.lines < small_screen then
      window.position = 'right'
      window.height = nil
      window.width = 0.4
    end

    Snacks.terminal.toggle(nil, {win = window})
  end

  local float_term = function(cmd)
    local window = {border = 'rounded'}
    if vim.o.lines < small_screen then
      window = {height = 0, width = 0}
    end

    window.position = 'float'
    Snacks.terminal.toggle(cmd, {win = window, interactive = true})
  end

  command('ToggleShell', toggle_shell, {nargs = '?'})

  command('GitStatus', function() float_term({'tig', 'status'}) end, {})

  command('GitBlame', function()
    float_term({'tig', 'blame', vim.fn.expand('%:p')})
  end, {})
end

function user.nvim_version()
  local version = vim.version()
  local str = string.format(
    'v%s.%s.%s',
    version.major,
    version.minor,
    version.patch
  )

  return {text = {str, hl = 'Comment'}, align = 'center'}
end

function user.dashboard_actions()
  local action = {
    new_file = {
      icon = '➤',
      key = 'n',
      desc = 'New File',
      action = ':enew',
    },
    search_file = {
      icon = '➤',
      key = 'ff',
      desc = 'Find File',
      action = function()
        require('telescope.builtin').find_files()
      end,
    },
    recently_used = {
      icon = '➤',
      key = 'fh',
      desc = 'History',
      action = function()
        require('telescope.builtin').oldfiles()
      end,
    },
    help = {
      icon = '➤',
      key = 'H',
      desc = 'Get Help',
      action = function()
        require('telescope.builtin').help_tags()
      end,
      hidden = true,
    },
    explore = {
      icon = '➤',
      key = 'e',
      desc = 'Explore',
      action = ':FileExplorer!'
    },
    restore_session = {
      icon = '➤',
      key = 's',
      desc = 'Restore Session',
      action = ':ResumeWork'
    },
    quit = {
      icon = '➤',
      key = 'q',
      desc = 'Quit',
      action = ':quitall',
    },
    open_last = {
      icon = '',
      key = 'o',
      desc = 'Open last',
      action = '<C-o><C-o>',
      hidden = true
    },
    lazy_ui = {
      icon = '',
      key = 'L',
      desc = 'Lazy',
      action = ':Lazy',
      hidden = true
    },
  }

  -- hide actions in very small screens
  if vim.o.lines < small_screen then
    action.new_file.hidden = true
    action.restore_session.hidden = true
    action.quit.hidden = true
  end

  return {
    action.new_file,
    action.search_file,
    action.recently_used,
    action.explore,
    action.restore_session,
    action.quit,
    action.lazy_ui,
    action.open_last,
    action.help,
  }
end

return Plugin


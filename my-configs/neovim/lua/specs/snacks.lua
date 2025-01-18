-- A collection of small QoL plugins
local Plugin = {'folke/snacks.nvim'}
local small_screen = vim.g.env_small_screen or 19
local user = {}

function Plugin.opts()
  return {
    bigfile = user.bigfile(),
    dashboard = user.dashboard_opts(),
    picker = {
      enabled = true,
      ui_select = true,
    },
    input = {
      enabled = true,
      icon = '❯',
    },
    indent = {
      enabled = false,
      char = '▏',
    },
    scope = {
      enabled = false,
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
  }
end

function Plugin.config(opts)
  local Snacks = require('snacks')
  Snacks.setup(opts())

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

function user.bigfile()
  return {
    enabled = true,
    notify = false,
    size = 1024 * 1024,
    setup = function(ctx)
      if vim.fn.has('nvim-0.11') == 0 then
        vim.cmd('syntax clear')
        vim.opt_local.syntax = 'OFF'
        vim.treesitter.stop(ctx.buf)
        vim.bo.filetype = 'bigfile'
      end

      vim.opt_local.foldmethod = 'manual'
      vim.opt_local.undolevels = -1
      vim.opt_local.undoreload = 0
      vim.opt_local.list = false

      if vim.fn.exists(':NoMatchParen') ~= 0 then
        vim.cmd('NoMatchParen')
      end
    end,
  }
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

function user.dashboard_opts()
  local version = vim.version()
  local version_str = string.format(
    'v%s.%s.%s',
    version.major,
    version.minor,
    version.patch
  )

  return {
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
      {text = {version_str, hl = 'Comment'}, align = 'center'},
    },
  }
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
    specs_actions = {
      icon = '',
      key = 'L',
      desc = 'Plugin manager',
      action = ':Spec',
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
    action.open_last,
    action.help,
    action.specs_actions,
  }
end

return Plugin


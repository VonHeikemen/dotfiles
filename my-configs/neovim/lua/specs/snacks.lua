-- A collection of small QoL plugins
local Plugin = {'folke/snacks.nvim'}
local small_screen = vim.g.env_small_screen or 19
local user = {}

function Plugin.opts()
  return {
    bigfile = user.bigfile(),
    picker = user.picker(),
    dashboard = user.dashboard(),
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
  local bind = vim.keymap.set
  local Snacks = require('snacks')

  Snacks.setup(opts())

  Snacks.toggle.indent():map('<leader>ui')

  bind('n', '<leader>bc', '<cmd>lua Snacks.bufdelete()<cr>')
  bind('n', '<leader>ds', '<cmd>lua Snacks.scratch()<cr>')

  bind('n', '<leader>bb', '<cmd>lua Snacks.picker("buffers")<cr>')
  bind('n', '<leader>ff', '<cmd>lua Snacks.picker("files")<cr>')
  bind('n', '<leader>fs', '<cmd>lua Snacks.picker("lines")<cr>')
  bind('n', '<leader>fh', '<cmd>lua Snacks.picker("recent")<cr>')
  bind('n', '<leader>fu', '<cmd>lua Snacks.picker("undo")<cr>')
  bind('n', '<leader>?', '<cmd>lua Snacks.picker("keymaps")<cr>')
  bind('n', '<leader>/', '<cmd>lua Snacks.picker("pickers")<cr>')

  bind('n', '<leader>fb', '<cmd>lua Snacks.picker("git_log_line")<cr>')

  user.snack_terminal()
end

function user.bigfile()
  local opts = {
    enabled = true,
    notify = false,
    size = 1024 * 1024, -- 1MB
  }

  opts.setup = function(ctx)
    if vim.fn.has('nvim-0.11') == 0 then
      vim.cmd('syntax clear')
      vim.opt_local.syntax = 'OFF'
      local buf = vim.b[ctx.buf]
      if buf.ts_highlight then
        vim.treesitter.stop(ctx.buf)
      end
    end

    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.undolevels = -1
    vim.opt_local.undoreload = 0
    vim.opt_local.list = false

    if vim.fn.exists(':NoMatchParen') ~= 0 then
      vim.cmd('NoMatchParen')
    end
  end

  return opts 
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

function user.picker()
  local opts = {
    enabled = true,
    prompt = ' ',
    layouts = {},
    win = {},
    icons = {
      files = {
        enabled = false,
      },
    },
    formatters = {
      file = {
        truncate = 78,
      },
    },
    actions = {
      noop = function() end,
    },
  }

  opts.layouts.palette = {
    preview = false,
    layout = {
      backdrop = false,
      row = 0.08,
      width = 0.4,
      min_width = 80,
      height = 0.4,
      min_height = 10,
      box = 'vertical',
      border = 'rounded',
      title = '{source} {live} {flags}',
      title_pos = 'center',
      {win = 'input', height = 1, border = 'bottom'},
      {win = 'list', border = 'none'},
    },
  }

  opts.sources = {
    files = {layout = 'palette'},
    buffers = {layout = 'palette'},
    recent = {layout = 'palette'},
    keymaps = {
      layout = {
        preview = false,
        preset = 'dropdown'
      }
    },
  }

  opts.win.input = {
    keys = {
      ['<Esc>'] = {'close', mode = {'n', 'i'}},
      ['<M-b>'] = {'confirm', mode = {'n', 'i'}},
      ['<M-k>'] = {'list_up', mode = {'n', 'i'}},
      ['<M-j>'] = {'list_down', mode = {'n', 'i'}},
      ['<C-l>'] = {'noop', mode = {'n', 'i'}},
      ['<C-l>d'] = {'inspect', mode = {'n', 'i'}},
      ['<C-l>i'] = {'toggle_ignored', mode = {'n', 'i'}},
      ['<C-l>h'] = {'toggle_hidden', mode = {'n', 'i'}},
      ['<C-l>l'] = {'toggle_live', mode = {'n', 'i'}},
      ['<C-l>w'] = {'toggle_focus', mode = {'n', 'i'}},
      ['<C-l>p'] = {'toggle_preview', mode = {'n', 'i'}},
    }
  }

  opts.win.list = {keys = opts.win.input.keys}

  if vim.o.lines < small_screen then
    opts.layouts.palette.layout.row = 1
  end

  return opts
end

function user.dashboard()
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
      action = ':lua Snacks.picker("files")'
    },
    recently_used = {
      icon = '➤',
      key = 'fh',
      desc = 'History',
      action = ':lua Snacks.picker("recent")'
    },
    help = {
      icon = '➤',
      key = 'H',
      desc = 'Get Help',
      action = ':lua Snacks.picker("help")',
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


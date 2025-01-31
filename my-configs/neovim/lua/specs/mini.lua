local Plugins = {}
local Plug = function(spec) table.insert(Plugins, spec) end

local event = {'SpecVimEdit'}

Plug {
  'echasnovski/mini.ai',
  user_event = event,
  opts = {
    custom_textobjects = {
      b = {{'%b()'}, '^.().*().$'},
      B = {{'%b{}'}, '^.().*().$'},
      s = {{'%b[]'}, '^.().*().$'},
    },
  },
  config = function(opts)
    require('mini.ai').setup(opts)
  end
}

Plug {
  'echasnovski/mini.surround',
  user_event = event,
  opts = {
    search_method = 'cover_or_next',
    mappings = {
      add = 'sa',
      delete = 'sd',
      replace = 'ss',
      find = '',
      find_left = '',
      highlight = '',
      update_n_lines = '',
    },
  },
  config = function(opts)
    require('mini.surround').setup(opts)
  end
} 

Plug {
  'echasnovski/mini.notify',
  opts = {
    lsp_progress = {
      enable = false,
    },
  },
  config = function(opts)
    local notify = require('mini.notify') 

    notify.setup(opts)
    vim.notify = notify.make_notify()

    vim.keymap.set('n', '<leader><space>', function()
      vim.cmd("echo ''")
      notify.clear()
    end)

    vim.api.nvim_create_user_command(
      'Notifications',
      'lua MiniNotify.show_history()',
      {}
    )
  end,
}

Plug {
  'echasnovski/mini.comment',
  user_event = event,
  opts = function(ts_context)
    local config = {options = {}}
    local cs = ts_context.calculate_commentstring

    config.options.custom_commentstring = function()
      return cs() or vim.bo.commentstring
    end

    return config
  end,
  config = function(opts)
    vim.cmd('SpecEvent ts-comment')
    local ts = require('ts_context_commentstring')
    require('mini.comment').setup(opts(ts))
  end,
}

Plug {
  'JoosepAlviste/nvim-ts-context-commentstring',
  user_event = {'ts-comment'},
  opts = {enable_autocmd = false},
  init = function()
    vim.g.skip_ts_context_commentstring_module = true
  end,
  config = function(opts)
    require('ts_context_commentstring').setup(opts)
  end,
}

Plug {
  'echasnovski/mini-git',
  user_event = event,
  init = function()
    vim.g.minigit_disable = true
  end,
  config = function()
    local bind = vim.keymap.set
    local autocmd = vim.api.nvim_create_autocmd
    local command = vim.api.nvim_create_user_command
    local group = vim.api.nvim_create_augroup('minigit_cmds', {clear = true})

    require('mini.git').setup({})

    bind('n', 'gid', '<cmd>Git diff<cr>')
    bind('n', 'gi*', '<cmd>GitShowDiff<cr>')
    bind('n', 'gib', '<cmd>GitBlameLine<cr>')

    command('GitShowDiff', function()
      require('mini.git').show_at_cursor()
    end, {})

    command('GitBlameLine', function()
      local line = vim.api.nvim_win_get_cursor(0)[1]
      local location = string.format('-L%s,%s:%%', line, line)

      vim.cmd({
        cmd = 'Git',
        args = {'log', '--no-patch', location},
      })
    end, {})

    autocmd('User', {
      pattern = 'MiniGitCommandSplit',
      group = group,
      callback = function(event)
        bind('n', 'q', '<cmd>close<cr>', {buffer = event.buf})
      end
    })

    autocmd('FileType', {
      pattern = {'git'},
      group = group,
      callback = function(event)
        local opts = {buffer = event.buf}
        bind('n', 'gib', '<Nop>', opts)
        bind('n', 'gd', '<cmd>GitShowDiff<cr>', opts)
      end
    })
  end,
}

return Plugins


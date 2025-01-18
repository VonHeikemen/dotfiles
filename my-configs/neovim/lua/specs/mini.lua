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
    require('mini.notify').setup(opts)

    vim.notify = require('mini.notify').make_notify()

    vim.keymap.set('n', '<leader><space>', function()
      vim.cmd("echo ''")
      require('mini.notify').clear()
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
  opts = {
    options = {
      custom_commentstring = function()
        local cs = require('ts_context_commentstring')
        return cs.calculate_commentstring() or vim.bo.commentstring
      end,
    },
  },
  config = function(opts)
    require('mini.comment').setup(opts)
  end,
}

Plug {
  'JoosepAlviste/nvim-ts-context-commentstring',
  user_event = event,
  opts = {enable_autocmd = false},
  init = function()
    vim.g.skip_ts_context_commentstring_module = true
  end,
  config = function(opts)
    require('ts_context_commentstring').setup(opts)
  end,
}

return Plugins


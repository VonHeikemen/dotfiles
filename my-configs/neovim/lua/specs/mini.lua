local Plugins = {}
local Plug = function(s) table.insert(Plugins, s) end

Plug {
  'echasnovski/mini.ai',
  branch = 'stable',
  main = 'mini.ai',
  config = true,
  keys = {
    {'a', mode = {'x', 'o'}},
    {'i', mode = {'x', 'o'}},
  },
}

Plug {
  'JoosepAlviste/nvim-ts-context-commentstring',
  main = 'ts_context_commentstring',
  lazy = true,
  opts = {
    enable_autocmd = false,
  },
  init = function()
    vim.g.skip_ts_context_commentstring_module = true
  end,
}

Plug {
  'echasnovski/mini.comment',
  branch = 'stable',
  main = 'mini.comment',
  keys = {
    'gcc',
    {'gc', mode = {'n', 'x', 'o'}},
  },
  opts = {
    options = {
      custom_commentstring = function()
        local cs = require('ts_context_commentstring').calculate_commentstring()
        return cs or vim.bo.commentstring
      end,
    },
  },
}

Plug {
  'echasnovski/mini.surround',
  branch = 'stable',
  main = 'mini.surround',
  keys = {
    'sa',
    'sd',
    'ss',
  },
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
} 

Plug {
  'echasnovski/mini.bracketed',
  branch = 'stable',
  main = 'mini.bracketed',
  keys = {
    {'[g', "<cmd>lua MiniBracketed.conflict('backward')<cr>", mode = {'n', 'x'}},
    {']g', "<cmd>lua MiniBracketed.conflict('forward')<cr>", mode = {'n', 'x'}},

    {'[q', "<cmd>lua MiniBracketed.quickfix('backward')<cr>"},
    {']q', "<cmd>lua MiniBracketed.quickfix('forward')<cr>"},
  },
  opts = {
    buffer     = {suffix = ''},
    comment    = {suffix = ''},
    conflict   = {suffix = ''},
    diagnostic = {suffix = ''},
    file       = {suffix = ''},
    indent     = {suffix = ''},
    jump       = {suffix = ''},
    location   = {suffix = ''},
    oldfile    = {suffix = ''},
    quickfix   = {suffix = ''},
    treesitter = {suffix = ''},
    undo       = {suffix = ''},
    window     = {suffix = ''},
    yank       = {suffix = ''},
  },
}

Plug {
  'echasnovski/mini.notify',
  branch = 'stable',
  main = 'mini.notify',
  lazy = true,
  opts = {
    lsp_progress = {
      enable = false,
    },
  },
  init = function()
    vim.notify = function(...)
      local notify = require('mini.notify').make_notify()
      vim.notify = notify
      return notify(...)
    end   

    vim.keymap.set('n', '<leader><space>', function()
      vim.cmd("echo ''")
      require('mini.notify').clear()
    end)
  end,
}

return Plugins


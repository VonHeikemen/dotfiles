local Plugins = {}
local Plug = function(s) table.insert(Plugins, s) end

Plug {
  'echasnovski/mini.ai',
  branch = 'stable',
  keys = {
    {'a', mode = {'x', 'o'}},
    {'i', mode = {'x', 'o'}},
  },
  config = function()
    require('mini.ai').setup()
  end,
}

Plug {
  'echasnovski/mini.comment',
  branch = 'stable',
  keys = {
    'gcc',
    {'gc', mode = {'n', 'x', 'o'}},
  },
  opts = {
    hooks = {
      pre = function()
        require('ts_context_commentstring.internal').update_commentstring()
      end,
    },
  },
  config = function(_, opts)
    require('mini.comment').setup(opts)
  end,
}

Plug {
  'echasnovski/mini.bufremove',
  branch = 'stable',
  keys = {{'<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>'}},
  config = function()
    require('mini.bufremove').setup()
  end,
}

Plug {
  'echasnovski/mini.surround',
  branch = 'stable',
  keys = {
    'ds',
    'cs',
    'ys',
    {'Y', "<Esc><cmd>lua MiniSurround.add('visual')<cr>", mode = 'x'},
  },
  opts = {
    search_method = 'cover_or_next',
    mappings = {
      add = 'ys',
      delete = 'ds',
      replace = 'cs',
      find = '',
      find_left = '',
      highlight = '',
      update_n_lines = '',
    },
  },
  config = function(_, opts)
    require('mini.surround').setup(opts)
    vim.keymap.del('x', 'ys')
  end,
} 

Plug {
  'echasnovski/mini.bracketed',
  branch = 'stable',
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
  config = function(_, opts)
    require('mini.bracketed').setup(opts)
  end
}

return Plugins


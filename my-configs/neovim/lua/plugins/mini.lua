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
  keys = {{'<Leader>bc', '<cmd>lua MiniBufremove.delete()<cr>'}},
  config = function()
    require('mini.bufremove').setup()
  end,
}

Plug {
  'echasnovski/mini.surround',
  branch = 'stable',
  keys = {
    {'ds', "v:lua.MiniSurround.operator('delete') . ' '", expr = true},
    {'cs', "v:lua.MiniSurround.operator('replace') . ' '", expr = true},
    {'ys', "v:lua.MiniSurround.operator('add')", expr = true},
    {'Y', ":<C-u>lua MiniSurround.add('visual')<cr>", mode = 'x'},
  },
  opts = {
    search_method = 'cover',
    mappings = {
      add = '',
      delete = '',
      replace = '',
      find = '',
      find_left = '',
      highlight = '',
      update_n_lines = '',
    },
  },
  config = function(_, opts)
    require('mini.surround').setup(opts)
  end,
} 

Plug {
  'echasnovski/mini.bracketed',
  branch = 'stable',
  keys = {
    {'[c', "<Cmd>lua MiniBracketed.conflict('backward')<CR>", mode = {'n', 'x'}},
    {']c', "<Cmd>lua MiniBracketed.conflict('forward')<CR>", mode = {'n', 'x'}},

    {'[q', "<Cmd>lua MiniBracketed.quickfix('backward')<CR>"},
    {']q', "<Cmd>lua MiniBracketed.quickfix('forward')<CR>"},
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


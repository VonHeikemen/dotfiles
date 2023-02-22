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

return Plugins


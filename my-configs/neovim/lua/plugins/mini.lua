local Plugins = {}
local Plug = function(s) table.insert(Plugins, s) end
local config = function(_, o) require(o[1]).setup() end

Plug {
  'echasnovski/mini.ai',
  branch = 'stable',
  opts = {'mini.ai'},
  config = config,
}

Plug {
  'echasnovski/mini.comment',
  branch = 'stable',
  opts = {
    'mini.comment',
    hooks = {
      pre = function()
        require('ts_context_commentstring.internal').update_commentstring()
      end,
    },
  },
  config = config,
}

Plug {
  'echasnovski/mini.bufremove',
  branch = 'stable',
  keys = {{'<Leader>bc', '<cmd>lua MiniBufremove.delete()<cr>'}},
  opts = {'mini.bufremove'},
  config = config,
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


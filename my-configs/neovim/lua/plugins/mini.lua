local config = function(_, o) require(o[1]).setup() end

local mini_ai = {
  'echasnovski/mini.ai',
  branch = 'stable',
  opts = {'mini.ai'},
  config = config,
}

local comment = {
  'echasnovski/mini.comment',
  branch = 'stable',
  opts = {'mini.comment'},
  config = config,
}

local bufremove = {
  'echasnovski/mini.bufremove',
  branch = 'stable',
  keys = {{'<Leader>bc', '<cmd>lua MiniBufremove.delete()<cr>'}},
  opts = {'mini.bufremove'},
  config = config,
}

local surround = {
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

return {
  mini_ai,
  comment,
  bufremove,
  surround,
}


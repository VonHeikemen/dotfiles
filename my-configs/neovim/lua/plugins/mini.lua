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
  'echasnovski/mini.comment',
  branch = 'stable',
  main = 'mini.comment',
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
}

Plug {
  'echasnovski/mini.bufremove',
  branch = 'stable',
  main = 'mini.bufremove',
  config = true,
  keys = {{'<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>'}},
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

return Plugins


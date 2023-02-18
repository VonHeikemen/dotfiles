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
  opts = {'mini.bufremove'},
  config = config,
  keys = {{'<Leader>bc', '<cmd>lua MiniBufremove.delete()<cr>'}}
}

local surround = {
  'echasnovski/mini.surround',
  branch = 'stable',
  opts = {
    search_method = 'cover',
    mappings = {
      add = '',
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
    vim.keymap.set('x', 'Y', ":<C-u>lua MiniSurround.add('visual')<cr>")
    vim.keymap.set('n', 'ys', "v:lua.MiniSurround.operator('add')", {expr = true})
  end
} 

surround.keys = function()
  local mappings = surround.opts.mappings
  return {
    {'ys'},
    {'Y', mode = 'x'},
    {mappings.delete},
    {mappings.replace},
  }
end

return {
  mini_ai,
  comment,
  bufremove,
  surround,
}


local plugins = {
  'fzf-tags',
  'fzf.vim',
  'kommentary',
  'lightspeed.nvim',
  'LuaSnip',
  'nvim-autopairs',
  'nvim-compe',
  'nvim-treesitter',
  'nvim-treesitter-textobjects',
  'quickfix-reflector.vim',
  'targets.vim',
  'vim-abolish',
  'vim-bbye',
  'vim-obsession',
  'vim-qf',
  'vim-repeat',
  'vim-surround',
}

local lazy_loading = function()
  local cmd = ''
  local add = 'packadd %s\n'
  for i, plug in pairs(plugins) do
    cmd = cmd .. add:format(plug)
  end

  vim.cmd(cmd)
  vim.cmd [[
    runtime OPT ftdetect/*.vim
    runtime OPT after/ftdetect/*.vim
    runtime OPT after/plugin/*.vim
  ]]

  require 'conf.functions'.try_load_again()
end

return function()
  vim.defer_fn(lazy_loading, 50)
end

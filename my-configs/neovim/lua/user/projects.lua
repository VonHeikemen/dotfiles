local function cmp_lua()
  -- Setup autocomplete for nvim's lua api
  require('cmp').setup.filetype('lua', {
    sources = {
      {name = 'path'},
      {name = 'nvim_lua'},
      {name = 'nvim_lsp', keyword_length = 3},
      {name = 'buffer', keyword_length = 3},
      {name = 'luasnip', keyword_length = 2},
    }
  })
end

return {
  nvim_config = function()
    cmp_lua()
    require('lsp').start('nvim_lua', {
      settings = {
        Lua = {
          workspace = {
            library = {
              vim.fn.expand('$VIMRUNTIME/lua'),
              vim.fn.stdpath('config') .. '/lua',
            },
          },
        }
      }
    })
  end,

  nvim_plugin = function(opts)
    local dependencies = {vim.fn.expand('$VIMRUNTIME/lua')}
    local lua = 'lua/%s'

    if opts.dependencies then
      for i, path in pairs(opts.dependencies) do
        dependencies[i + 1] = vim.fn.fnamemodify(
          vim.api.nvim_get_runtime_file(lua:format(path), true)[1],
          ':h'
        )
      end
    end

    cmp_lua()
    require('lsp').start('nvim_lua', {
      settings = {
        Lua = {
          workspace = {library = dependencies},
        }
      }
    })
  end
}


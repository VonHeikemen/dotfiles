local M = {}

function M.setup(opts)
  opts = opts or {}

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

  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local library = {
    -- Make the server aware of Neovim runtime files
    vim.fn.expand('$VIMRUNTIME/lua'),
    vim.fn.stdpath('config') .. '/lua'
  }

  if opts.library then
    library = opts.library
  end

  require('lsp').start('sumneko_lua', {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = 'LuaJIT',
          path = runtime_path
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'}
        },
        workspace = {
          library = library,
        },
      }
    }
  })
end

return M


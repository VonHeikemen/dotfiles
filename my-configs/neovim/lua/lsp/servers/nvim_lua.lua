local defaults = require('lsp.servers.sumneko_lua')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

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

local server = vim.tbl_deep_extend('force', defaults, {
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
        library = {
          vim.fn.expand('$VIMRUNTIME/lua'),
          vim.fn.stdpath('config') .. '/lua'
        },
      },
    }
  }
})

return server


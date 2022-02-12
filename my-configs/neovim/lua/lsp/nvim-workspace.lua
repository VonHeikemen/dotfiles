local M = {}
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

-- Options for sumneko_lua
local config = function()
  return {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'}
        },
        workspace = {
          library = {
            -- Make the server aware of Neovim runtime files
            vim.fn.expand('$VIMRUNTIME/lua'),
            vim.fn.stdpath('config') .. '/lua'
          }
        }
      }
    }
  }
end

M.simple_config = function()
  return config()
end

M.full_config = function()
  local opts = config()
  opts.settings.Lua.workspace.library = vim.api.nvim_get_runtime_file('', true)
  return opts
end

M.setup_full_config = function()
  local opts = M.full_config()
  opts.here = true
  vim.cmd('LspStop')
  require('lsp').setup('sumneko_lua', opts)

  vim.cmd('LspRestart')
end

M.setup = function()
  local opts = M.simple_config()
  opts.here = true
  require('lsp').setup('sumneko_lua', opts)

  local noremap = {noremap = true, silent = true}
  vim.api.nvim_set_keymap('n', '<F6>', '<cmd>lua require("lsp.nvim-workspace").setup_full_config()<cr>', noremap)
end

return M


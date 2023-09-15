local Project = {}

local function cmp_lua()
  local cmp = require('cmp')
  local sources = vim.deepcopy(cmp.get_config().sources)
  table.insert(sources, {name = 'nvim_lua'})

  -- Setup autocomplete for nvim's lua api
  cmp.setup.filetype('lua', {sources = sources})
end

function Project.nvim_config()
  vim.cmd('Lsp')

  local lsp_zero = require('lsp-zero')
  local lua_opts = {
    settings = {
      Lua = {
        workspace = {
          library = {
            vim.fn.expand('$VIMRUNTIME/lua'),
            vim.fn.stdpath('config') .. '/lua',
          }
        },
      }
    }
  }

  cmp_lua()
  lsp_zero.use('nvim_lua', lua_opts)
end

function Project.nvim_plugin(opts)
  vim.cmd('Lsp')

  local lsp_zero = require('lsp-zero')
  local dependencies = {vim.fn.expand('$VIMRUNTIME/lua')}
  local lua = vim.fn.stdpath('data') .. '/lazy/*/lua/%s'

  if opts.dependencies then
    for i, mod in ipairs(opts.dependencies) do
      local path = vim.fn.glob(lua:format(mod))
      dependencies[i + 1] = path == '' and nil or path
    end
  end

  local lua_opts = {
    settings = {
      Lua = {
        workspace = {
          library = dependencies
        },
      }
    }
  }

  cmp_lua()
  lsp_zero.use('nvim_lua', lua_opts)
end

return Project


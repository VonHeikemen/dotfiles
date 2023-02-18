local M = {}
local lsp = {}

local function nvim_api()
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  local server_config = {
    name = 'nvim_lua',
    cmd = {'lua-language-server'},
    filetypes = {'lua'},
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path
        },
        diagnostics = {
          globals = {'vim'}
        },
        workspace = {
          library = {
            vim.fn.expand('$VIMRUNTIME/lua'),
          },
          checkThirdParty = false
        },
        telemetry = {
          enable = false
        },
      }
    }
  }

  return server_config
end

function lsp.nvim_lua()
  local configs = require('lspconfig.configs')

  if configs.nvim_lua == nil then
    configs.nvim_lua = {default_config = nvim_api()}
  end

  return {}
end

function lsp.tsserver()
  return {
    settings = {
      completions = {
        completeFunctionCalls = true
      }
    }
  }
end

function M.get(name)
  local fn = lsp[name]
  if fn == nil then
    return {}
  end

  return fn()
end

function M.start(name, opts)
  opts = opts or {}

  opts.single_file_support = false
  opts.capabilities = require('cmp_nvim_lsp').default_capabilities()

  if opts.root_dir == nil then
    opts.root_dir = function() return vim.fn.getcwd() end
  end

  local defaults = M.get(name)

  local lsp = require('lspconfig')[name]

  lsp.setup(vim.tbl_deep_extend('force', defaults, opts))

  if lsp.manager and vim.bo.filetype ~= '' then
    lsp.manager.try_add_wrapper()
  end
end

return M


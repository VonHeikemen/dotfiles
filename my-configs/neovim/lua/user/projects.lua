local Project = {}

local function cmp_source(ft, new_source)
  local cmp = require('cmp')
  local sources = vim.deepcopy(cmp.get_config().sources)

  for _, s in pairs(new_source) do
    table.insert(sources, {name = s, keyword_length = 3})
  end

  cmp.setup.filetype(ft, {sources = sources})
end

function Project.nvim_config()
  vim.cmd('Lsp')
  cmp_source('lua', {'nvim_lua'})

  require('lsp-zero').use('nvim_lua', {})
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

  cmp_source('lua', {'nvim_lua'})

  lsp_zero.use('nvim_lua', lua_opts)
end

function Project.legacy_php()
  local cmp = require('cmp')
  local config = {}
  config.sources = {
    {name = 'omni'},
    {name = 'tags'},
  }

  cmp.setup.filetype('php', {
    mapping = {
      ['<C-l>'] = cmp.mapping(function()
        vim.cmd('UserCmpEnable')
        cmp.complete({config = config})
      end)
    }
  })

  vim.keymap.set('n', 'gd', "<cmd>exe 'tjump' expand('<cword>')<cr>")
end

return Project


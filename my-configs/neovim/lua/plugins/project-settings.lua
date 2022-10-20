local project = require('project-settings')
local enable = project.utils.enable

local augroup = vim.api.nvim_create_augroup('project_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd

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

project.set_config({
  settings = {
    notify_unregistered = false,
    notify_changed = false,
    file_pattern = './vimrc.json'
  },
  allow = {
    lsp = function(opts)
      require('lsp').project_setup(opts)
    end,

    autoindent = enable(function()
      require('user.functions').set_autoindent()
    end),

    session = function(name)
      if type(name) ~= 'string' then
        return
      end

      vim.g.session_name = name
    end,

    ['null-ls'] = enable(function()
      require('lsp.null-ls').setup()
    end),

    ['nvim-config'] = enable(function()
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
    end),

    ['nvim-plugin'] = function(opts)
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
})

autocmd('BufWritePost', {
  pattern = 'vimrc.json',
  group = augroup,
  command = 'ProjectSettingsRegister'
})


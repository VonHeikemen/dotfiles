local project = require('project-settings')
local enable = project.utils.enable

local augroup = vim.api.nvim_create_augroup('project_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd

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
      require('conf.functions').set_autoindent()
    end),

    session = function(name)
      if type(name) ~= 'string' then return end
      vim.g.session_name = name
    end,

    ['nvim-config'] = enable(function()
      require('lsp.nvim-workspace').setup()
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

      require('lsp.nvim-workspace').setup({library = dependencies})
    end
  }
})

autocmd('BufWritePost', {
  pattern = 'vimrc.json',
  group = augroup,
  command = 'ProjectSettingsRegister'
})


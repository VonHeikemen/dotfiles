local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'project'
Plugin.dir = vim.fs.joinpath(path, 'pack', Plugin.name)

function Plugin.init()
  local env = require('user.env')
  if env.project_store then
    vim.g.project_store_path = env.project_store
  end
end

function Plugin.config()
  vim.keymap.set('n', '<leader>de', '<cmd>ProjectStore<cr>')
  vim.keymap.set('n', '<leader>dc', '<cmd>ProjectEditConfig<cr>')
end

return Plugin


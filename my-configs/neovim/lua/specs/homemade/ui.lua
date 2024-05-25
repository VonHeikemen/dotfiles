local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'ui'
Plugin.dir = vim.fs.joinpath(path, 'pack', Plugin.name)
Plugin.config = false
Plugin.lazy = false

return Plugin


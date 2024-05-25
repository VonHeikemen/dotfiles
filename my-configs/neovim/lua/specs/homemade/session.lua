local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'session'
Plugin.dir = vim.fs.joinpath(path, 'pack', Plugin.name)
Plugin.config = false

return Plugin


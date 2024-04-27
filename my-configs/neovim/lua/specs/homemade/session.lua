local function join(arg) return table.concat(arg, '/') end
local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'session'
Plugin.dir = join({path, 'pack', Plugin.name})
Plugin.config = false

return Plugin


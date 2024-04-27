local function join(arg) return table.concat(arg, '/') end
local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'ui'
Plugin.dir = join({path, 'pack', Plugin.name})
Plugin.config = false
Plugin.lazy = false

return Plugin


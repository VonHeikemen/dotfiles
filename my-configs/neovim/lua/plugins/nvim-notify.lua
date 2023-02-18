-- Pretty notifications
local Plugin = {'rcarriga/nvim-notify'}

Plugin.lazy = true

Plugin.opts = {
  stages = 'slide',
  level = 'DEBUG',
  background_colour = vim.g.terminal_color_background,
  minimum_width = 15
}

function Plugin.init()
  vim.notify = function(...)
    local notify = require('notify')
    vim.notify = notify
    return notify(...)
  end   
end

return Plugin


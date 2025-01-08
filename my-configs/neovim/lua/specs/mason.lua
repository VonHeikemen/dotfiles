-- Installs and update commandline tools
local Plugin = {'williamboman/mason.nvim'}

Plugin.user_event = {'SpecDefer', 'mason'}

function Plugin.config()
  require('mason').setup({
    ui = {border = 'rounded'}
  })
end

return Plugin


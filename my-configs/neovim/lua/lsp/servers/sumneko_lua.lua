local config = require('lsp.config')

local server = config.make({
  cmd = {'lua-language-server'},
  name = 'sumneko_lua',
  filetypes = {'lua'},
  settings = {
    Lua = {
      telemetry = {enable = false},
      workspace = {checkThirdParty = false}
    }
  }
})

return server


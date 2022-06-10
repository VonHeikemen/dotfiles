local shared = require('lsp.configs.shared')

local filetypes = {'lua'}

local server = shared.make_config({
  cmd = {'lua-language-server'},
  name = 'sumneko_lua',
  filetypes = filetypes,
  settings = {
    Lua = {
      telemetry = {enable = false},
      workspace = {checkThirdParty = false}
    }
  }
})

return server


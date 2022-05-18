local shared = require('lsp.configs.shared')

local filetypes = {lua = true}

local server = shared.make_config({
  cmd = {'lua-language-server'},
  name = 'sumneko_lua',
  settings = {
    Lua = {
      telemetry = {enable = false},
      workspace = {checkThirdParty = false}
    }
  }
})

return {
  filetypes = filetypes,
  params = server
}


local shared = require('lsp.configs.shared')

local filetypes = {
  'javascript',
  'javascriptreact',
  'javascript.jsx',
  'typescript',
  'typescriptreact',
  'typescript.tsx'
}

local server = shared.make_config({
  cmd = {'typescript-language-server', '--stdio'},
  name = 'tsserver',
  filetypes = filetypes,
})

return server


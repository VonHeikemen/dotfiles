local config = require('lsp.config')

local server = config.make({
  cmd = {'typescript-language-server', '--stdio'},
  name = 'tsserver',
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx'
  },
  settings = {
    completions = {
      completeFunctionCalls = true
    }
  },
})

return server


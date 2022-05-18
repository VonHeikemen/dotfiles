local shared = require('lsp.configs.shared')

local filetypes = {
  javascript = true,
  javascriptreact = true,
  ['javascript.jsx'] = true,
  typescript = true,
  typescriptreact = true,
  ['typescript.tsx'] = true
}

local server = shared.make_config({
  cmd = {'typescript-language-server', '--stdio'},
  name = 'tsserver',
})

return {
  filetypes = filetypes,
  params = server
}


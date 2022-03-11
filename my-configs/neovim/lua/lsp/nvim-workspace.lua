local M = {}

M.setup = function(include_all)
  -- Setup autocomplete for nvim's lua api
  require('cmp').setup.filetype('lua', {
    sources = {
      {name = 'path'},
      {name = 'nvim_lua'},
      {name = 'nvim_lsp', keyword_length = 3},
      {name = 'buffer', keyword_length = 3},
      {name = 'luasnip', keyword_length = 2},
    }
  })

  require('lsp')

  local lsp = require('lsp-zero')

  if include_all then
    lsp.nvim_workspace({
      library = vim.api.nvim_get_runtime_file('', true)
    })
  else
    lsp.nvim_workspace()
  end

  lsp.use('sumneko_lua')
end

return M


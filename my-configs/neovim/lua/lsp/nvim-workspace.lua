local M = {}

M.setup = function(opts)
  opts = opts or {}

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

  local server_opts = lsp.defaults.nvim_workspace()

  if opts.library then
    server_opts.settings.Lua.workspace.library = opts.library
  end

  lsp.use('sumneko_lua', server_opts)
end

return M


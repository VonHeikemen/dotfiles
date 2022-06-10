local M = {}

local fmt = string.format

M.start = function(name, opts)
  vim.lsp.start_client(M.config(name, opts))
end

M.config = function(name, opts)
  local server_opts = require(fmt('lsp.configs.%s', name))

  if opts then
    server_opts = vim.tbl_deep_extend(
      'force',
      server_opts,
      opts
    )
  end

  return server_opts
end

return M


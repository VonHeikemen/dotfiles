local M = {}

local fmt = string.format

M.start = function(name, opts)
  local config = M.config(name, opts)
  vim.lsp.start_client(config.params)
end

M.config = function(name, opts)
  local server_opts = require(fmt('lsp.configs.%s', name))

  if opts then
    server_opts.params = vim.tbl_deep_extend(
      'force',
      server_opts.params,
      opts
    )
  end

  return server_opts
end

M.buf_attach = function(name, id)
  local server_opts = require(fmt('lsp.configs.%s', name))

  local supported = server_opts.filetypes[vim.bo.filetype]
  if not supported then return end

  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.buf_attach_client(bufnr, id)
end

return M


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

M.format = function(client, bufnr)
  local params = vim.lsp.util.make_formatting_params({})
  client.request('textDocument/formatting', params, nil, bufnr)
end

M.format_sync = function(client, bufnr)
  local params = vim.lsp.util.make_formatting_params({})
  local result = client.request_sync('textDocument/formatting', params, 5 * 1000, bufnr)

  if result and result.result then
    vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
  end
end

M.range_format = function(client, bufnr, options)
  local params = vim.lsp.util.make_given_range_params()
  params.options = vim.lsp.util.make_formatting_params(options).options

  client.request('textDocument/rangeFormatting', params)
end

M.format_cmd = function(input, client, bufnr)
  local has_range = input.line2 == input.count
  local execute = M.format

  if input.bang then
    if has_range then return end
    execute = M.format_sync
  end

  if has_range then
    execute = M.range_format
  end

  execute(client, bufnr)
end

return M


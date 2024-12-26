local function lsp_attach(event)
  local id = vim.tbl_get(event, 'data', 'client_id')
  local client = id and vim.lsp.get_client_by_id(id)
  if client == nil then
    return
  end

  -- Disable semantic highlights
  client.server_capabilities.semanticTokensProvider = nil
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = lsp_attach,
})

if package.loaded['user.diagnostics'] == nil then
  require('user.diagnostics')
end

if vim.fn.has('nvim-0.11') == 0 then
  local style = 'rounded'
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = style}
  ) 
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = style}
  ) 
end


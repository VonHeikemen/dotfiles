local group = vim.api.nvim_create_augroup('lsp_cmds', {clear = true})

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

require('user.diagnostics')

vim.cmd('SpecEvent nvim-cmp')


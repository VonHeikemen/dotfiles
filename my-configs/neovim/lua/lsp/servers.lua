local server = {}

local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

server.sumneko_lua = {
  capabilities = capabilities,
  settings = {
    Lua = {
      telemetry = {enable = false}
    }
  }
}

server.tsserver = {
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 500,
  },
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
  end
}

return server


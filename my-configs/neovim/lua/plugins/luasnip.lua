local luasnip = require('luasnip')
local snippets = require('luasnip.loaders.from_vscode')

luasnip.config.set_config({
  history = false,
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave'
})

snippets.lazy_load()
local filetype = vim.bo.filetype

if vim.fn.argc() > 0 and filetype ~= '' then
  snippets.load({include = {filetype}})
end


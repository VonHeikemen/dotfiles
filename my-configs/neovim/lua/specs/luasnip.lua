-- Snippet engine
local Plugin = {'L3MON4D3/LuaSnip'}
Plugin.depends = {'VonHeikemen/the-good-snippets'}

Plugin.user_event = {'CmpReady'}

Plugin.opts = {
  keep_roots = false,
  link_roots = false,
  link_children = false,
  region_check_events = 'InsertEnter',
  delete_check_events = 'InsertLeave'
}

function Plugin.config(opts)
  local luasnip = require('luasnip')
  local snippets = require('luasnip.loaders.from_vscode')

  luasnip.config.set_config(opts)

  snippets.lazy_load()
  local filetype = vim.bo.filetype

  if filetype ~= '' then
    snippets.load({include = {filetype}})
  end
end

function Plugin.update()
  if vim.fn.executable('make') == 1 then
    vim.fn.system('make install_jsregexp')
  end
end

return Plugin


local plug = require('plugins.manager')

if plug.has_minpac() then
  return false
end

plug.skip_config = true

plug.minpac_download()

local plugins = plug.get_plugins()

if vim.tbl_isempty(plugins) then
  return
end

plug.init(plugins)
plug.minpac()

local function quit_nvim()
  vim.fn.confirm('You need to restart neovim to complete install process')
  vim.cmd('quitall')
end

vim.call('minpac#update', '', {['do'] = quit_nvim})

return true


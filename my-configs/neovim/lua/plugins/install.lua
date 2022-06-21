local plug = require('plugins.manager')

if plug.has_minpac() then
  return false
end

plug.skip_config = true

local quit_nvim = function()
  vim.fn.confirm('You need to restart neovim to complete install process')
  vim.cmd('quitall')
end

plug.minpac_download()

require('user.plugins')
plug.minpac()

vim.call('minpac#update', '', {['do'] = quit_nvim})

return true


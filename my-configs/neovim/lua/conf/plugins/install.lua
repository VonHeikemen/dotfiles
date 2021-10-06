local plug = require('plug')

if plug.has_minpac() then
  return
end

plug.skip_config = true
require('conf.commands')
require('conf.plugins')

plug.minpac_download()
plug.minpac()
vim.call('minpac#update')


local plug = require('plug')

if plug.has_minpac() then
  return
end

plug.skip_config = true

plug.minpac_download()
plug.minpac()
vim.call('minpac#update')


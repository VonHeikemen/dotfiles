-- Only load plugin specs on Neovim v0.12 or greater
if vim.fn.has('nvim-0.12') == 0 then
  return
end

require('offspec').setup({
  -- when using a "short url" assume the plugin comes from github
  default_host = 'https://github.com',
  -- path to plugin configs
  import_dir = vim.fs.joinpath(
    vim.fn.stdpath('config') --[[@as string]],
    'lua',
    'specs'
  )
})


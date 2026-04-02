local group = vim.api.nvim_create_augroup('offspec', {clear = true})
local nvim_data = vim.fn.stdpath('data') --[[@as string]]
local nvim_config = vim.fn.stdpath('config') --[[@as string]]
local packpath = vim.fs.joinpath(nvim_data, 'site', 'pack', 'core', 'opt')
local import_dir = vim.fs.joinpath(nvim_config, 'lua', 'specs')

return {
  augroup = group,
  import_dir = import_dir,
  default_host = 'https://github.com',
  patch_fs_dir = false,
  queue_init = {},
  queue_config = {},
  queue_handler = {},
  loaded_plugins = {},
  start_plugins = {},
  lazy_plugins = {},
  packpath = packpath,
}


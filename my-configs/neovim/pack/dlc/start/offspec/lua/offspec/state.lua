local group = vim.api.nvim_create_augroup('offspec', {clear = true})
local nvim_data = vim.fn.stdpath('data') --[[@as string]]
local packpath = vim.fs.joinpath(nvim_data, 'site', 'pack', 'core', 'opt')

return {
  augroup = group,
  import_dir = '',
  default_host = '',
  patch_fs_dir = false,
  queue_init = {},
  queue_config = {},
  queue_handler = {},
  loaded_plugins = {},
  start_plugins = {},
  lazy_plugins = {},
  packpath = packpath,
}


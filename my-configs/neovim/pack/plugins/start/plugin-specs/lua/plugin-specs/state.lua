local group = vim.api.nvim_create_augroup('plugin_specs', {clear = true})
local nvim_data = vim.fn.stdpath('data') --[[@as string]]
local use_fallback = vim.pack == nil
local packpath = ''

if use_fallback then
  packpath = vim.fs.joinpath(nvim_data, 'site', 'pack', 'deps', 'opt')
else
  packpath = vim.fs.joinpath(nvim_data, 'site', 'pack', 'core', 'opt')
end

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
  use_fallback = use_fallback,
  packpath = packpath,
}


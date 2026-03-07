local group = vim.api.nvim_create_augroup('plugin_specs', {clear = true})

return {
  augroup = group,
  import_dir = '',
  default_host = '',
  queue_init = {},
  queue_config = {},
  queue_handler = {},
  loaded_plugins = {},
}


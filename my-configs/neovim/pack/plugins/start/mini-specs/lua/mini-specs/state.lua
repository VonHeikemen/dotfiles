local group = vim.api.nvim_create_augroup('mini_specs', {clear = true})

return {
  augroup = group,
  lazy_load = true,
  all_plugins = {},
  loaded = {},
  import_dir = '',
}


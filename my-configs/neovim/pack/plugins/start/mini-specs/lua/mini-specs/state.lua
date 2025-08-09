local group = vim.api.nvim_create_augroup('mini_specs', {clear = true})
local nvim_data = vim.fn.stdpath('data') --[[@as string]]

return {
  augroup = group,
  lazy_load = true,
  all_plugins = {},
  loaded = {},
  import_dir = '',
  config = {
    path = {
      package_path = vim.fs.joinpath(nvim_data, 'site'),
    }
  }
}


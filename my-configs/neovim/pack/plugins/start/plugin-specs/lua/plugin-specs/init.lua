local M = {}

function M.setup(opts)
  local state = require('plugin-specs.state')

  if type(opts.import_dir) == 'string'  then
    state.import_dir = opts.import_dir
  end

  if type(opts.patch_fs_dir) == 'boolean'  then
    state.patch_fs_dir = opts.patch_fs_dir
  end

  if state.import_dir == '' then
    return
  end

  if type(opts.default_host) == 'string' then
    state.default_host = opts.default_host
  end

  vim.go.packpath = table.concat({
    vim.env.VIMRUNTIME,
    vim.fn.stdpath('config'),
    vim.fs.joinpath(vim.fn.stdpath('data'), 'site')
  }, ',')

  local source = require('plugin-specs.source')
  local specs = source.scandir(state.import_dir)

  if state.use_fallback then
    local vendor = require('plugin-specs.vendor')
    local deps = vendor.require_deps()
    if deps.setup == nil then
      return
    end

    vendor.manage(deps, specs, state)
  else
    require('plugin-specs.vim-pack').manage(specs, state)
  end

  source.load(state)
end

return M


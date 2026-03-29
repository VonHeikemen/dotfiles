local M = {}

function M.setup(opts)
  local state = require('offspec.state')

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

  local source = require('offspec.source')
  local specs = source.scandir(state.import_dir)

  if state.use_fallback then
    local vendor = require('offspec.vendor')
    local deps = vendor.require_deps()
    if deps.setup == nil then
      return
    end

    vendor.manage(deps, specs, state)
  else
    require('offspec.vim-pack').manage(specs, state)
  end

  source.load(state)
end

function M.event(events)
  local opts = {
    group = require('offspec.state').augroup,
    modeline = false,
  }

  if type(events) == 'string' then
    events = {events}
  end

  for _, event in ipairs(events) do
    opts.pattern = event
    vim.api.nvim_exec_autocmds('User', opts)
  end
end

return M


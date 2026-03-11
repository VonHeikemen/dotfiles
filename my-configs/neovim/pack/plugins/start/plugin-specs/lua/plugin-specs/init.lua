local M = {}
local H = {}

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
    H.manage(specs, state)
  end

  source.load(state)
end

function M.commands()
  local command = vim.api.nvim_create_user_command

  command('Spec', function()
    M.actions()
  end, {})

  command('SpecUpdate', function()
    vim.pack.update()
  end, {})

  command('SpecRestore', function()
    vim.pack.update(nil, {target = 'lockfile'})
  end, {})

  command('SpecErrors', function()
    require('plugin-specs.source').report_errors()
  end, {})

  command('SpecEvent', function(input)
    M.event(input.fargs)
  end, {nargs = '*'})

  command('SpecRemove', function(input)
    vim.pack.del({input.args})
  end, {nargs = 1})

  command('SpecShow', function(input)
    local param = input.args
    local show = vim.print
    if input.bang then
      show = function(a) vim.notify(vim.inspect(a)) end
    end

    if param == 'session' then
      show(vim.pack.get())
      return
    end

    if param == 'installed' then
      vim.pack.update(nil, {offline = true})
      return
    end

    vim.print('sub-commands: "session" "installed"')
  end, {nargs = '?', bang = true})
end

function M.event(events)
  local opts = {
    group = require('plugin-specs.state').augroup,
    modeline = false,
  }

  if type(events) == 'string' then
    events = {events}
  end

  for _, event in pairs(events) do
    opts.pattern = event
    vim.api.nvim_exec_autocmds('User', opts)
  end
end

function M.actions()
  local items = {
    {'Update plugins', 'SpecUpdate'},
    {'Report errors', 'SpecErrors'},
    {'Restore from lockfile', 'SpecRestore'},
    {'Inspect session', 'SpecShow! session'},
    {'Installed plugins', 'SpecShow installed'},
  }

  local options = vim.tbl_map(function(i) return i[1] end, items)

  vim.ui.select(options, {prompt = 'Plugin manager'}, function(choice, i)
    if choice == nil then
      return
    end

    vim.cmd(items[i][2])
  end)
end

function H.manage(specs, state)
  local noop = function() end

  if state.patch_fs_dir then
    H.patch_add(specs, {load = noop})
    return
  end

  vim.pack.add(specs, {load = noop})
end

function H.patch_add(specs, opts)
  local nvim_fs_dir = vim.fs.dir
  local packpath = require('plugin-specs.state').packpath

  local fs_dir_patch = function(path, fs_opts)
    local plugin_dir = path == packpath
    if not plugin_dir  then
      return nvim_fs_dir(path, fs_opts)
    end

    local iter = vim.iter(vim.fn.globpath(path, '*', 0, 1))
      :map(function(i) return vim.fn.fnamemodify(i, ':t') end)

    return function()
      return iter:next(), 'directory'
    end
  end

  vim.fs.dir = fs_dir_patch
  vim.pack.add(specs, opts)
  vim.fs.dir = nvim_fs_dir
end

return M


local M = {}
local H = {}

function M.manage(specs, state)
  local noop = function() end

  if state.patch_fs_dir then
    H.patch_add(specs, {load = noop})
    return
  end

  vim.pack.add(specs, {load = noop})
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


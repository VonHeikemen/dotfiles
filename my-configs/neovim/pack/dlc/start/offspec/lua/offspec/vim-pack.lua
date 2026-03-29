local M = {}
local H = {}

function M.manage(specs, state)
  local noop = function() end

  H.packchanged(state)

  if state.patch_fs_dir then
    H.patch_add(specs, {load = noop})
    return
  end

  vim.pack.add(specs, {load = noop})
end

function M.commands()
  local command = vim.api.nvim_create_user_command

  command('Spec', M.actions, {})

  command('SpecUpdate', function()
    vim.pack.update()
  end, {})

  command('SpecRestore', function()
    vim.pack.update(nil, {target = 'lockfile'})
  end, {})

  command('SpecErrors', function()
    require('offspec.source').report_errors()
  end, {})

  command('SpecLog', function()
    local path = vim.fs.joinpath(vim.fn.stdpath('log'), 'nvim-pack.log')
    vim.cmd.view(path)
    vim.keymap.set('n', 'q', '<cmd>bdelete<cr>', {buffer = true, nowait = true})
  end, {})

  command('SpecEvent', function(input)
    require('offspec').event(input.fargs)
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

function M.actions()
  local items = {
    {'Update plugins', 'SpecUpdate'},
    {'Show update logs', 'SpecLog'},
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
  local packpath = require('offspec.state').packpath

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

function H.packchanged(state)
  vim.api.nvim_create_autocmd('PackChanged', {
    group = state.augroup,
    desc = 'Execute plugin callbacks',
    callback = function(event)
      local data = event.data or {}
      local kind = data.kind or ''
      local callback = vim.tbl_get(data, 'spec', 'data', 'on_' .. kind)

      -- possible callbacks: on_install, on_update, on_delete
      if type(callback) ~= 'function' then
        return
      end

      local ok, err = pcall(callback, data)
      if not ok then
        local msg = '[spec]: %s %s callback failed:\n%s'
        local name = vim.tbl_get(data, 'spec', 'name') or 'plugin'
        vim.notify(msg:format(name, kind, err), vim.log.levels.WARN)
      end
    end,
  })
end

return M


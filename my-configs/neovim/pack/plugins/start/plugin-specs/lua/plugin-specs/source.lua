local M = {}
local H = {error_messages = {}}

function M.scandir(import_path)
  local uv = vim.uv
  local join = vim.fs.joinpath
  local make_spec = H.make_spec
  local warn = vim.log.levels.WARN
  local all_specs = {}

  local source = function(name, index)
    local path = join(import_path, name)
    local chunk = loadfile(path)

    if chunk == nil then
      local msg = '[plugin-spec]: Failed to process "%s"'
      vim.notify(msg:format(name), warn)
      return
    end

    local err, Plug = pcall(chunk)
    if type(Plug) ~= 'table' then
      local msg = '[plugin-spec]: Invalid spec "%s"'
      vim.notify(msg:format(name), warn)
      vim.notify(err, warn)
      return
    end

    local kind = type(Plug[1])
    if kind == 'string' then
      if Plug.enabled ~= false then
        local index = #all_specs
        table.insert(all_specs, make_spec(Plug, index))
      end
      return
    end

    if kind ~= 'table' then
      return
    end

    for _, p in ipairs(Plug) do
      if type(p) == 'table' and type(p[1]) == 'string' then
        if p.enabled ~= false then
          local index = #all_specs
          table.insert(all_specs, make_spec(p, index))
        end
      end
    end
  end

  local handle = uv.fs_scandir(import_path)
  while handle do
    local name, kind = uv.fs_scandir_next(handle)
    if name == nil then
      break
    end

    if kind == 'file' then
      source(name, index)
    end
  end

  return all_specs
end

function M.load(specs, state)
  local start_plugins = {}
  local lazy_plugins = {}

  local process = function(arg)
    local data = arg.spec.data
    local info = {
      name = vim.fn.escape(arg.spec.name, ' '),
      config = tostring(data.config_id),
    }

    if data.start_plugin then
      table.insert(start_plugins, info)
    else
      table.insert(lazy_plugins, info)
    end
  end

  vim.pack.add(specs, {load = process})

  -- Execute Plugin.init callbacks
  for _, f in ipairs(state.queue_init) do
    M.safe_call(f)
  end
  state.queue_init = nil

  -- Load start plugins
  for _, i in ipairs(start_plugins) do
    M.packadd(i, state)
  end

  -- Setup handlers for lazy plugins
  for _, i in ipairs(lazy_plugins) do
    for _, handler in ipairs(state.queue_handler[i.config]) do
      M.safe_call(function() handler(i) end)
    end
  end
  state.queue_handler = nil

  if #H.error_messages > 0 then
    local msg = '[plugin-specs]: There were errors in Plugin callbacks.\n'
      .. 'Use the command :SpecErrors to show details.'

    local notify = vim.schedule_wrap(vim.notify)
    notify(msg, vim.log.levels.WARN)
  end
end

function M.safe_call(fn)
  local ok, err = pcall(fn)
  if not ok then
    table.insert(H.error_messages, err)
  end
end

function M.packadd(info, state)
  vim.cmd.packadd({info.name, magic = {file = false}})

  local config_fn = state.queue_config[info.config]
  if config_fn then
    M.safe_call(config_fn)
    state.queue_config[info.config] = nil
  end

  if vim.v.vim_did_enter == 1 then
    local plug = vim.pack.get({info.name})[1]
    local after = vim.fn.glob(plug.path .. '/after/plugin/**/*.{vim,lua}', false, true)
    for _, path in ipairs(after) do
      vim.cmd.source({path, magic = {file = false}})
    end
  end
end

function M.packadd_callback(info)
  return function()
    local state = require('plugin-specs.state')
    require('plugin-specs.source').packadd(info, state)
  end
end

function M.report_errors()
  if #H.error_messages == 0 then
    vim.notify('[plugin-spec]: There no errors to report')
    return
  end

  local msg = '[plugin-spec]: Plugin spec runtime errors:\n\n'
    .. table.concat(H.error_messages, '\n\n')

  H.error_messages = {}
  vim.notify(msg, vim.log.levels.ERROR)
end


function H.make_spec(Plugin, index)
  local spec = {data = {}}
  local state = require('plugin-specs.state')
  local augroup = state.augroup

  if type(Plugin.host) == 'string' then
    spec.src = string.format('%s/%s', Plugin.host, Plugin[1])
  elseif state.default_host ~= '' then
    spec.src = string.format('%s/%s', state.default_host, Plugin[1])
  else
    spec.src = Plugin[1]
  end

  spec.data.config_id = index

  local init_fn = Plugin.init
  local config_fn = Plugin.config

  if type(init_fn) == 'function' then
    table.insert(state.queue_init, init_fn)
  end

  if type(config_fn) == 'function' then
    local opts = Plugin.opts
    state.queue_config[tostring(index)] = function() config_fn(opts) end
  end

  local lazy = type(Plugin.event or Plugin.cmd or Plugin.user_event) ~= 'nil'

  if not lazy then
    spec.data.start_plugin = true
    return spec
  end

  spec.data.start_plugin = false
  local handlers = {}

  local events = Plugin.event
  if type(events) == 'table' then
     local h = function(info)
      vim.api.nvim_create_autocmd(events, {
        group = augroup,
        once = true,
        desc = string.format('Lazy load %s', info.name),
        callback = M.packadd_callback(info)
      })
    end

    table.insert(handlers, h)
  end

  local user_events = Plugin.user_event
  if type(user_events) == 'table' then
    local h = function(info)
      vim.api.nvim_create_autocmd('User', {
        group = augroup,
        pattern = user_events,
        once = true,
        desc = string.format('Lazy load %s', info.name),
        callback = M.packadd_callback(info)
      })
    end

    table.insert(handlers, h)
  end

  local cmds = Plugin.cmd
  if type(cmds) == 'table' then
    local h = function(info)
      H.cmd_loader(cmds, info)
    end

    table.insert(handlers, h)
  end

  state.queue_handler[tostring(index)] = handlers

  return spec
end

function H.cmd_loader(commands, info)
  local make_cmd = vim.api.nvim_create_user_command

  for _, name in ipairs(commands) do
    local do_cmd = function(input)
      local state = require('plugin-specs.state')
      M.packadd(info, state)

      local bang = input.bang and '!' or ''
      local range = input.range

      if range == 0 then
        range = ''
      elseif range == 1 then
        range = input.count
      elseif range == 2 then
        range = string.format('%s,%s', input.line1, input.line2)
      end

      local cmd = string.format('%s%s%s %s', range, name, bang, input.args)
      vim.cmd(cmd)
    end

    make_cmd(name, do_cmd, {
      nargs = '*',
      range = true,
      bang = true,
    })
  end
end

return M


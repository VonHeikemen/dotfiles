local M = {}
local H = {}

local state = require('mini-specs.state')
local mini = require('mini.deps')
local join = vim.fs.joinpath

function M.scandir(import_path)
  local uv = vim.uv
  local include = H.include
  local warn = vim.log.levels.WARN

  local source = function(name)
    local path = join(import_path, name)
    local chunk = loadfile(path)

    if chunk == nil then
      local msg = 'Failed to process "%s"'
      vim.notify(msg:format(name), warn)
      return
    end

    local err, config = pcall(chunk)
    if type(config) ~= 'table' then
      local msg = 'Invalid spec "%s"'
      vim.notify(msg:format(name), warn)
      vim.notify(err, warn)
      return
    end

    local kind = type(config[1])
    if kind == 'string' then
      include(config)
      return
    end

    if kind ~= 'table' then
      return
    end

    for _, c in ipairs(config) do
      if type(c) == 'table' and type(c[1]) == 'string' then
        include(c)
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
      source(name)
    end
  end
end

function H.include(Plugin)
  if Plugin.enabled == false then
    return
  end

  local id = Plugin[1]
  local is_lazy = type(Plugin.event or Plugin.cmd or Plugin.user_event) ~= 'nil'
  state.loaded[id] = false

  Plugin.is_lazy = state.lazy_load and is_lazy

  if type(Plugin.config) == 'function' then
    local user_config = Plugin.config
    local opts = Plugin.opts
    Plugin.load_config = function()
      if state.loaded[id] then
        return
      end
      mini.now(function() user_config(opts) end)
      state.loaded[id] = true
    end
  else
    Plugin.load_config = function()
      state.loaded[id] = true
    end
  end

  if type(Plugin.init) == 'function' then
    mini.now(Plugin.init)
  end

  local spec = H.make_spec(Plugin)
  table.insert(state.all_plugins, spec)

  if Plugin.is_lazy then
    H.lazy_load(Plugin, spec)
    return
  end

  mini.now(function()
    mini.add(spec)
    Plugin.load_config()
  end)
end

function H.make_spec(Plugin)
  local spec = {
    source = Plugin[1],
    checkout = Plugin.rev,
  }

  if Plugin.update then
    spec.hooks = {post_checkout = Plugin.update}
  end

  if Plugin.depends then
    spec.depends = {}
    for _, c in pairs(Plugin.depends) do
      local kind = type(c)
      if kind == 'string' then
        table.insert(spec.depends, c)
      elseif kind == 'table' then
        local d = H.make_spec(c)
        table.insert(spec.depends, d)
      end
    end
  end

  return spec
end

function H.lazy_load(Plugin, spec)
  if Plugin.event then
    H.event_loader('builtin', Plugin, spec)
  end
  if Plugin.user_event then
    H.event_loader('user', Plugin, spec)
  end
  if Plugin.cmd then
    H.cmd_loader(Plugin, spec)
  end
end

function H.event_loader(kind, Plugin, spec)
  local events
  local patterns
  local callback = Plugin.load_config

  if kind == 'builtin' then
    events = Plugin.event
  elseif kind == 'user' then
    events = 'User'
    patterns = Plugin.user_event
  end

  local desc = 'Lazy load %s'

  vim.api.nvim_create_autocmd(events, {
    group = state.augroup,
    pattern = patterns,
    once = true,
    desc = desc:format(Plugin[1]),
    callback = function()
      if spec then
        mini.add(spec)
      end
      mini.now(callback)
    end,
  })
end

function H.cmd_loader(Plugin, spec)
  local commands = Plugin.cmd
  local callback = Plugin.load_config
  local kind = type(commands)

  if kind == 'string' then
    commands = {commands}
  end

  if kind ~= 'table'  then
    return
  end

  local make_cmd = vim.api.nvim_create_user_command

  for _, name in ipairs(commands) do
    local do_cmd = function(input)
      if spec then
        mini.add(spec)
      end
      mini.now(callback)

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


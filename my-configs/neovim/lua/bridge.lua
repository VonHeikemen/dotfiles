local M = {}
__User_fns = __User_fns or {}

local module_name = 'bridge'
local id = 0
local fns = __User_fns
local augroups = {}

M.apply = function(name, arg)
  if fns[name] then
    return fns[name](arg)
  end
end

_G._apply_user_fn = M.apply

M.register = function(name, fn)
  fns[name] = fn
end

M.lua_call = function(name)
  return string.format("lua require('%s').apply('%s')", module_name, name)
end

M.lua_cmd = function(fn)
  id = id + 1
  local name = 'cmd_' .. id
  M.register(name, fn)
  return M.lua_call(name)
end

M.lua_expr = function(fn)
  id = id + 1
  local name = 'expr_' .. id
  M.register(name, fn)
  return string.format("v:lua._apply_user_fn('%s')", name)
end

M.lua_map = function(fn)
  id = id + 1
  local name = 'map_' .. id
  M.register(name, fn)
  return string.format('<cmd>%s<CR>', M.lua_call(name))
end

M.create_excmd = function(cmd_name, fn)
  opts = {}
  local user_fn = fn

  if type(user_fn) == 'table' then
    user_fn = fn[1]
    for i, v in pairs(fn) do
      if type(i) == 'string' then opts[i] = v end
    end
  end

  M.register(cmd_name, user_fn)

  if not opts.user_input then
    local cmd = [[ command! %s %s ]]
    vim.cmd(cmd:format(cmd_name, M.lua_call(cmd_name)))
    return
  end

  local cmd = [[ command! -nargs=1 %s %s ]]
  local call = ("lua require('%s').apply('%s', <q-args>)"):format(module_name, cmd_name)

  vim.cmd(cmd:format(cmd_name, call))
end

M.register_augroups = function(groups, force_reset)
  force_reset = force_reset or false

  local reset_group = [[
    if exists('#%s')
      augroup %s
        autocmd!
      augroup END
      augroup! %s
    endif
  ]]

  for i, group in ipairs(groups) do
    if force_reset or not augroups[group] then
      augroups[group] = true
      vim.cmd(reset_group:format(group, group, group))
    end
  end
end

M.group_command = function(group, event, command)
  if not augroups[group] then
    error(('You need to register the augroup "%s"'):format(group))
  end

  local add_cmd = [[
    augroup %s
      autocmd %s %s%s%s
    augroup END
  ]]

  local pattern = '*'
  local evt = event
  local once = ' '

  if type(event) == 'table' then
    evt = event[1]
    pattern = event[2] or '*'
    if event.once then
      once = ' ++once '
    end
  end

  local user_cmd = command

  if type(command) == 'function' then
    user_cmd = M.lua_cmd(command)
  end

  vim.cmd(add_cmd:format(group, evt, pattern, once, user_cmd))
end

M.augroup = function(group)
  M.register_augroups({group}, true)

  return function(event, command)
    return M.group_command(group, event, command)
  end
end

return M


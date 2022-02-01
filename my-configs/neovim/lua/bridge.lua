local M = {}

local module_name = 'bridge'
local id = 0
local fns = {}

M.apply = function(name, arg)
  fns[name](arg)
end

M.apply_expr = function(name)
  return vim.api.nvim_replace_termcodes(fns[name](), true, true, true)
end

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
  return string.format("v:lua.require'%s'.apply_expr('%s')", module_name, name)
end

M.lua_map = function(fn)
  id = id + 1
  local name = 'map_' .. id
  M.register(name, fn)
  return string.format('<cmd>%s<CR>', M.lua_call(name))
end

M.create_excmd = function(cmd_name, fn)
  opts = {}

  if type(cmd_name) == 'table' then
    for i, v in pairs(cmd_name) do
      if type(i) == 'string' then opts[i] = v end
    end
    cmd_name = cmd_name[1]
  end

  M.register(cmd_name, fn)

  if not opts.qargs then
    local cmd = [[ command! %s %s ]]
    vim.cmd(cmd:format(cmd_name, M.lua_call(cmd_name)))
    return
  end

  local cmd = [[ command! -nargs=1 %s %s ]]
  local call = string.format(
    "lua require('%s').apply('%s', <q-args>)",
    module_name,
    cmd_name
  )

  vim.cmd(cmd:format(cmd_name, call))
end

M.reset_augroups = function(groups)
  local reset_group = [[
    if exists('#%s')
      augroup %s
        autocmd!
      augroup END
      augroup! %s
    endif
  ]]

  for i, group in ipairs(groups) do
    vim.cmd(reset_group:format(group, group, group))
  end
end

M.group_command = function(group, event, command)
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
  M.reset_augroups({group})

  return function(event, command)
    return M.group_command(group, event, command)
  end
end

M.autocmd = function(event, command)
  return M.group_command('user_cmds', event, command)
end

return M


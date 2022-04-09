local M = {}

M.create_excmd = function(command, fn)
  local cmd_name, opts

  if type(command) == 'string' then
    cmd_name = command
    opts = {}
  else
    cmd_name = command[1]
    command[1] = nil
    opts = command
  end

  vim.api.nvim_add_user_command(cmd_name, fn, opts)
end

M.group_command = function(group, event, command)
  local name, opts

  if type(event) == 'string' then
    name = event
    opts = {group = group}
  else
    name = event[1]
    opts = event
    opts.pattern = event[2]
    opts[1] = nil
    opts[2] = nil
  end

  if type(command) == 'string' and command:sub(1, 1) == ':' then
    opts.command = command:sub(2)
  else
    opts.callback = command
  end

  return vim.api.nvim_create_autocmd(name, opts)
end

M.augroup = function(group)
  local id = vim.api.nvim_create_augroup(group, {clear = true})

  return function(event, command)
    M.group_command(id, event, command)
  end
end

M.autocmd = function(event, command)
  return M.group_command(
    vim.api.nvim_create_augroup('user_cmds', {clear = false}),
    event,
    command
  )
end

return M


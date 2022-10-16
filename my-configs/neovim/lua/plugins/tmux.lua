local M = {}
local pane_id = 'main:cmd'
local cmd = ''

local command = vim.api.nvim_create_user_command

function M.tmux_run(val, exec)
  local run = cmd

  if #val > 0 then
    run = val
  end

  if run == '' then
    vim.notify('[tmux] Need to specify a command', vim.log.levels.WARN)
    return
  end

  local args = {'tmux', 'send-keys', '-t', pane_id, run}

  if exec then
    table.insert(args, 'C-m')
  end

  vim.fn.jobstart(args)
end

function M.tmux_cmd(val)
  if #val > 0 then
    cmd = val
    return
  end

  vim.ui.input({prompt = 'tmux command'}, function(value)
    if value == nil then
      return
    end

    cmd = value
  end)
end

function M.tmux_pane(val)
  if #val > 0 then
    pane_id = val
    return
  end

  vim.ui.input({prompt = 'tmux pane'}, function(value)
    if value == nil then
      return
    end

    pane_id = value
  end)
end

function M.tmux_pwd()
  local cd = ' cd %s'
  M.tmux_run(cd:format(vim.fn.getcwd()), true)
end

local function parse_cmd(input)
  local index = input.args:find(' ') or 1
  local action = input.args:sub(1, index - 1)
  local args = input.args:sub(index + 1)

  if action == '' then
    action = input.args
    args = ''
  end

  local valid = {
    run = function(val) M.tmux_run(val, true) end,
    send = function(val) M.tmux_run(val, false) end,
    cmd = M.tmux_cmd,
    pane = M.tmux_pane,
    pwd = M.tmux_pwd
  }

  local fn = valid[action]
  if fn then
    fn(vim.trim(args))
  else
    vim.notify('[tmux] Invalid command', vim.log.levels.ERROR)
  end
end

command('Tmux', parse_cmd, {nargs = 1})

return M


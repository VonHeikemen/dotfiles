local M = {}
local pane_id = 'main:zsh'
local cmd = ''

function M.run(val, opts)
  local run = cmd
  local opts = opts or {}
  local cwd = opts.cwd or vim.fn.getcwd()

  if #val > 0 then
    run = val
  end

  if run == '' then
    vim.notify('[tmux] Need to specify a command', vim.log.levels.WARN)
    return
  end

  local args = {'tmux', 'send-keys', '-t', pane_id, run}

  if opts.exec then
    table.insert(args, 'C-m')
  end

  vim.fn.jobstart(args, {cwd = cwd})
end

function M.cache_cmd(val)
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

function M.cmd(val, exec)
  local run = ''

  if #val > 0 then
    run = val
  end

  if run == '' then
    vim.notify('[tmux] Need to specify a command', vim.log.levels.WARN)
    return
  end

  local args = {'tmux', run}
  vim.fn.jobstart(args)
end

function M.cache_pane(val)
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

function M.pwd()
  local cd = ' cd %s'
  M.run(cd:format(vim.fn.getcwd()), true)
end

function M.parse_cmd(input)
  local index = input.args:find(' ') or 1
  local action = input.args:sub(1, index - 1)
  local args = input.args:sub(index + 1)

  if action == '' then
    action = input.args
    args = ''
  end

  local valid = {
    cmd = M.cmd,
    pwd = M.pwd,
    run = function(val) M.run(val, {exec = true}) end,
    send = function(val) M.run(val, {exec = false}) end,
    ['cache-cmd'] = M.cache_cmd,
    ['cache-pane'] = M.cache_pane,
  }

  local fn = valid[action]
  if fn then
    fn(vim.trim(args))
  else
    vim.notify('[tmux] Invalid command', vim.log.levels.ERROR)
  end
end

return M


local command = vim.api.nvim_create_user_command

local function parse_cmd(input)
  local tmux = require('tmux')
  local index = input.args:find(' ') or 1
  local action = input.args:sub(1, index - 1)
  local args = input.args:sub(index + 1)

  if action == '' then
    action = input.args
    args = ''
  end

  local valid = {
    cmd = tmux.cmd,
    pwd = tmux.pwd,
    run = function(val) tmux.run(val, {exec = true}) end,
    send = function(val) tmux.run(val, {exec = false}) end,
    ['cache-cmd'] = tmux.cache_cmd,
    ['cache-pane'] = tmux.cache_pane,
  }

  local fn = valid[action]
  if fn then
    fn(vim.trim(args))
  else
    vim.notify('[tmux] Invalid command', vim.log.levels.ERROR)
  end
end

command('Tmux', parse_cmd, {nargs = 1})


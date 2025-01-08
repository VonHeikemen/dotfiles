local augroup = vim.api.nvim_create_augroup('session_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

command('SessionSave', function()
  require('session').save_current()
end, {})

command('SessionLoad', function(input)
  require('session').load_current(input.args)
end, {nargs = '?'})

command('SessionNew', function()
  vim.ui.input({prompt = 'Session name:'}, function(value)
    if value == nil then
      return
    end

    require('session').create(value)
  end)
end, {})

command('SessionNewBranch', function(input)
  require('session').new_branch(input.args)
end, {nargs = 1})

command('SessionLoadBranch', function(input)
  require('session').load_branch(input.args)
end, {nargs = 1})

command('SessionConfig', function(input)
  local session = vim.v.this_session
  if session == '' then
    return
  end

  local path = vim.fn.fnamemodify(session, ':r')
  vim.cmd.edit(path .. 'x.vim')
end, {})

command('SessionRestore', function(input)
  local session = require('session')
  local name = session.read_name(vim.fn.getcwd())

  if name then
    session.load_current(name)
  elseif input.bang then
    vim.cmd('quitall')
  else
    vim.notify('Session not available')
  end
end, {bang = true})

autocmd('VimLeavePre', {
  group = augroup,
  desc = 'Save active session on exit',
  callback = function(event)
    require('session').save_current(event)
  end
})


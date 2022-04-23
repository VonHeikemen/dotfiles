local M = {}

local augroup = vim.api.nvim_create_augroup('session_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command
local escape = vim.fn.fnameescape

local set_autocmd = nil
local join = function(...) return table.concat({...}, '/') end
local session_dir = join(vim.fn.stdpath('data'),  'sessions')

M.create = function(name)
  if name == nil or name == '' then return end

  local file = join(session_dir, name)

  if vim.fn.filereadable(file) == 1 then
    local msg = 'session file %s already exists'
    vim.notify(msg:format(name), vim.log.levels.ERROR)
    return
  end

  local mksession = 'mksession %s.vim'
  local ok = pcall(vim.cmd, mksession:format(escape(file)))

  if not ok and vim.fn.filereadable(session_dir) == 0 then
    vim.fn.mkdir(session_dir, 'p')
    pcall(vim.cmd, mksession:format(escape(file)))
  end

  vim.g.session_name = name
  M.autosave()
end

M.source = function(name)
  local file = escape(join(session_dir, name))
  local source = 'source %s.vim'

  vim.cmd(source:format(file))
  M.autosave()
end

M.is_readable = function(name)
  return vim.fn.filereadable(join(session_dir, name .. '.vim')) == 1
end

M.save = function()
  local session = vim.v.this_session
  if session == '' then return end

  vim.cmd('mksession! ' .. session)
end

M.autosave = function()
  if set_autocmd then return end

  set_autocmd = autocmd('VimLeavePre', {
    group = augroup,
    desc = 'Save active session on exit',
    callback = M.save
  })
end

M.load_current = function()
  local name = vim.g.session_name

  if name == nil then
    vim.ui.input({prompt = 'Session name:'}, function(value)
      if value == nil then return end
      M.create(value)
      vim.defer_fn(function() vim.cmd('enew') end, 5)
    end)
    return
  end

  if M.is_readable(name) then
    M.source(name)
    return
  end

  M.create(name)
end

local load_session = function(input)
  local name = input.args
  if name:len() > 0 then
    vim.g.session_name = name
  end

  M.load_current()
end

local new_session = function()
  vim.ui.input({prompt = 'Session name:'}, function(value)
    if value == nil then return end
    M.create(value)
  end)
end

local new_branch = function(input)
  if vim.g.session_name == nil then
    local msg = 'There is no active session.'
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  M.save()

  local branch = '%s::%s'
  M.create(branch:format(vim.g.session_name, input.args))
end

local load_branch = function(input)
  if vim.g.session_name == nil then
    local msg = 'There is no active session.'
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  M.save()

  local branch = '%s::%s'
  local name = branch:format(vim.g.session_name, input.args)

  if not M.is_readable(name) then
    local msg = 'Could not find branch %s'
    vim.notify(msg:format(name), vim.log.levels.ERROR)
    return
  end

  vim.g.session_name = name
  M.load_current()
end

command('SessionSave', M.save, {})
command('SessionLoad', load_session, {nargs = '?'})
command('SessionNew', new_session, {})
command('SessionNewBranch', new_branch, {nargs = 1})
command('SessionLoadBranch', load_branch, {nargs = 1})

return M


local M = {}

local augroup = vim.api.nvim_create_augroup('session_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command
local escape = vim.fn.fnameescape

local set_autocmd = nil
local function join(...) return table.concat({...}, '/') end
local session_dir = join(vim.fn.stdpath('data'),  'sessions')

function M.create(name)
  if name == nil or name == '' then
    return
  end

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

function M.source(name)
  local file = escape(join(session_dir, name))
  local source = 'source %s.vim'

  vim.cmd(source:format(file))
  M.autosave()
end

function M.is_readable(name)
  return vim.fn.filereadable(join(session_dir, name .. '.vim')) == 1
end

function M.save(name)
  local session = escape(join(session_dir, name .. '.vim'))
  vim.cmd('mksession! ' .. session)
end

function M.save_current()
  local session = vim.v.this_session
  if session == '' then
    return
  end

  vim.cmd('mksession! ' .. escape(session))
end

function M.autosave()
  if set_autocmd then
    return
  end

  set_autocmd = autocmd('VimLeavePre', {
    group = augroup,
    desc = 'Save active session on exit',
    callback = M.save_current
  })
end

function M.load_current(name)
  if name == nil then
    return
  end

  if M.is_readable(name) then
    M.source(name)
    return
  end
end

local function load_session(input)
  M.load_current(input.args)
end

function M.new_session()
  vim.ui.input({prompt = 'Session name:'}, function(value)
    if value == nil then
      return
    end

    M.create(value)
  end)
end

local function new_branch(input)
  if vim.g.session_name == nil then
    local msg = 'There is no active session.'
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  M.save_current()

  local branch = '%s::%s'
  local name = vim.split(vim.g.session_name, '::')[1]
  M.create(branch:format(name, input.args))
end

local function load_branch(input)
  if vim.g.session_name == nil then
    local msg = 'There is no active session.'
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  M.save_current()

  local branch = '%s::%s'
  local name = branch:format(
    vim.split(vim.g.session_name, '::')[1],
    input.args
  )

  if not M.is_readable(name) then
    local msg = 'Could not find branch %s'
    vim.notify(msg:format(name), vim.log.levels.ERROR)
    return
  end

  M.load_current(name)
end

command('SessionSave', M.save_current, {})
command('SessionLoad', load_session, {nargs = '?'})
command('SessionNew', M.new_session, {})
command('SessionNewBranch', new_branch, {nargs = 1})
command('SessionLoadBranch', load_branch, {nargs = 1})

return M


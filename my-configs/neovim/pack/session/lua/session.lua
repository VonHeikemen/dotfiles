local M = {}

local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

local function join(...) return table.concat({...}, '/') end
local session_dir = join(vim.fn.stdpath('data'),  'sessions')

local function mksession(file, bang)
  vim.cmd({cmd = 'mksession', args = {file}, bang = bang})
end

function M.create(name)
  if name == nil or name == '' then
    return
  end

  local file = join(session_dir, name .. '.vim')

  if vim.fn.filereadable(file) == 1 then
    local msg = 'session file %s already exists'
    vim.notify(msg:format(name), vim.log.levels.ERROR)
    return
  end

  local ok = pcall(mksession, file)

  if not ok and vim.fn.filereadable(session_dir) == 0 then
    vim.fn.mkdir(session_dir, 'p')
    pcall(mksession, file)
  end

  vim.g.session_name = name
end

function M.source(name, dir)
  local path = dir or session_dir
  local file = join(path, name .. '.vim')

  vim.g.session_name = name
  vim.cmd({cmd = 'source', args = {file}})
end

function M.is_readable(name)
  return vim.fn.filereadable(join(session_dir, name .. '.vim')) == 1
end

function M.save(name, dir)
  local path = dir or session_dir
  mksession(join(path, name .. '.vim'), true)
end

function M.save_current()
  local file = vim.v.this_session
  if file == '' then
    return
  end

  mksession(file, true)
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

function M.load_branch(session_name)
  if vim.g.session_name == nil then
    local msg = 'There is no active session.'
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  if session_name == '' then
    return
  end

  M.save_current()

  local branch = '%s::%s'
  local current = vim.fn.fnamemodify(vim.v.this_session, ':t:r')
  local name = branch:format(
    vim.split(current, '::')[1],
    session_name
  )

  if not M.is_readable(name) then
    local msg = 'Could not find branch %s'
    vim.notify(msg:format(name), vim.log.levels.ERROR)
    return
  end

  M.load_current(name)
end

function M.new_branch(branch_name)
  if vim.g.session_name == nil then
    local msg = 'There is no active session.'
    vim.notify(msg, vim.log.levels.ERROR)
    return
  end

  if branch_name == '' then
    return
  end

  M.save_current()

  local branch = '%s::%s'
  local current = vim.fn.fnamemodify(vim.v.this_session, ':t:r')
  local name = vim.split(current, '::')[1]

  M.create(branch:format(name, branch_name))
end

function M.read_name(dir)
  local paths = {
    join(dir, '.git', 'session-nvim'),
    join(dir, '.session-nvim')
  }

  for _, file in ipairs(paths) do
    if vim.fn.filereadable(file) == 1 then
      return vim.fn.readfile(file, '', 1)[1]
    end
  end
end

return M


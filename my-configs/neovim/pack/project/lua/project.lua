local function join(...) return table.concat({...}, '/') end

local M = {store = {}, cmd = {}}
local warn = vim.log.levels.WARN

local project_store
if vim.g.project_store_path then
  project_store = vim.g.project_store_path
else
  project_store = join(vim.fn.stdpath('data'), 'project-store')
end

---
-- Read/Save project
---
function M.set(name, state)
  local project_dir = join(project_store, name)

  if state == 'validate' and vim.fn.isdirectory(project_dir) == 0 then
    local msg = '"%s" folder does not exists.'
    vim.notify(msg:format(name), warn)
    return false
  end

  if state == 'empty' and vim.fn.isdirectory(project_dir) == 1 then
    local msg = '"%s" folder already exists.'
    vim.notify(msg:format(name), warn)
    return false
  end

  if state == 'empty' then
    vim.fn.mkdir(project_dir, 'p')
    local msg = '"%s" has been created.'
    vim.notify(msg:format(name))
  end

  M.store.current = name
  M.store.dir = project_dir
  return true
end

function M.get_current()
  local dir = vim.fn.getcwd()
  local paths = {
    join(dir, '.git', 'project-nvim'),
    join(dir, '.project-nvim')
  }

  for _, file in ipairs(paths) do
    if vim.fn.filereadable(file) == 1 then
      return vim.fn.readfile(file, '', 1)[1]
    end
  end
end

function M.create(name)
  return M.set(name, 'empty')
end

function M.load(opts)
  opts = opts or {}
  local branch = ''

  local name = opts.name
  local luarc = opts.luarc == nil and true or opts.luarc
  local session = opts.session == nil and true or opts.session

  if name == '' or type(name) ~= 'string' then
    name = M.get_current()
    if name == nil then
      local msg = 'Could not read project name for current folder'
      vim.notify(msg, warn)
      return
    end
  end

  local parts = vim.split(name, '::')
  if parts[2] then
    name = parts[1]
    branch = parts[2]
  end

  local ok = M.set(name, 'validate')
  if not ok then
    if opts.quit then
      vim.cmd('cquit 2')
    end

    return
  end

  M.store.branch = branch

  if luarc then
    M.source_luarc(opts.luarc)
  end

  if session then
    M.load_session(opts.session, branch)
  end
end

function M.source_luarc(name)
  if M.store.current == nil then
    local msg = 'Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  name = type(name) == 'string' and name or 'rc'
  local luarc = join(M.store.dir, name .. '.lua')
  if vim.fn.filereadable(luarc) == 1 then
    vim.cmd.source(luarc)
  end
end


---
-- Project session
---
function M.make_session(name)
  if M.store.current == nil then
    local msg = 'Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  name = type(name) == 'string' and name or 'Session'
  require('session').save(name, M.store.dir)
end

function M.load_session(name, branch)
  if M.store.current == nil then
    local msg = 'Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  name = type(name) == 'string' and name or 'Session'

  if branch ~= '' then
    name = string.format('%s::%s', name, branch)
  end

  local path = join(M.store.dir, name .. '.vim')

  if vim.fn.filereadable(path) == 0 then
    return
  end

  require('session').source(name, M.store.dir)

  if vim.v.this_session then
    M.store.session = vim.v.this_session
  end
end


---
-- BufferNav list
---
function M.save_buffer_list(name)
  if M.store.current == nil then
    local msg = 'Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  local path = join(M.store.dir, 'buffers')
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end

  local file = join(path, name or 'current')

  vim.cmd.BufferNavSave(file)
  M.store.buffer_list = file
end

function M.load_buffer_list(name)
  if M.store.current == nil then
    local msg = 'Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  name = name or 'current'
  local path = join(M.store.dir, 'buffers', name)
  if vim.fn.filereadable(path) == 1 then
    vim.cmd.BufferNavRead(path)
    M.store.buffer_list = path
  end
end


return M


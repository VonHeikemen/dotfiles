local M = {store = {}, cmd = {}}
local warn = vim.log.levels.WARN
local join = vim.fs.joinpath

local project_store
if vim.g.project_store_path then
  project_store = vim.g.project_store_path
else
  project_store = join(vim.fn.stdpath('data'), 'project-store')
end

---
-- Read/Save project
---
function M.set_store(name, state)
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
  return M.set_store(name, 'empty')
end

function M.set(opts)
  local opts = opts or {}
  if opts.project == nil then
    return
  end

  M.store.current = opts.project
  M.store.dir = join(project_store, opts.project)

  local callback = function()
    if opts.buffers then
      M.load_buffer_list(opts.buffers)
    end

    if opts.luarc then
      M.source_luarc('rc')
    end

    if opts.session then
      M.load_session(opts.session, '')
    end
  end

  if vim.v.vim_did_enter == 1 then
    vim.schedule(callback)
    return
  end

  vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = vim.schedule_wrap(callback)
  })
end

function M.load()
  local rc = vim.secure.read('./nvimrc.json')

  if rc == nil then
    local msg = '[project] Could not read nvimrc.json'
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  local config = vim.json.decode(rc)
  if type(config) ~= 'table' then
    local msg = '[project] Invalid format'
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  M.set(config)
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
    local msg = '[session] Project folder has not been set'
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
    local msg = '[buffers] Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  local path = join(M.store.dir, 'buffers')
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end

  local file = join(path, name or 'current')

  require('buffer-nav').save_content(file)
  M.store.buffer_list = file
end

function M.load_buffer_list(name)
  if M.store.current == nil then
    local msg = '[buffers] Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  name = name or 'current'
  local path = join(M.store.dir, 'buffers', name)
  if vim.fn.filereadable(path) == 1 then
    require('buffer-nav').load_content(path)
    M.store.buffer_list = path
  end
end

return M


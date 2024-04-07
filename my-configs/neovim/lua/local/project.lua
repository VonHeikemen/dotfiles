local function join(...) return table.concat({...}, '/') end
local env = require('user.env')

local M = {store = {}, cmd = {}}
local warn = vim.log.levels.WARN

local project_store
if env.project_store then
  project_store = env.project_store
else
  project_store = join(vim.fn.stdpath('data'), 'project-store')
end

function M.setup()
  M.plugin()

  vim.keymap.set('n', '<leader>de', '<cmd>ProjectStore<cr>')
  vim.keymap.set('n', '<leader>dp', '<cmd>ProjectEditConfig<cr>')
end

function M.plugin()
  local command = vim.api.nvim_create_user_command

  command('ProjectCreate', M.cmd.create, {nargs = '?'})
  command('ProjectChange', M.cmd.set, {nargs = '?'})
  command('ProjectLoad', M.cmd.load, {nargs = '?'})
  command('ProjectStore', M.cmd.browse_store, {})

  command('ProjectMakeSession', M.cmd.make_session, {nargs = '?'})
  command('ProjectSaveBuffers', M.cmd.save_buffers, {bang = true, nargs = '?'})
  command('ProjectReadBuffers', M.cmd.read_buffers, {nargs = '?'})
  command('ProjectEditConfig', M.cmd.edit_luarc, {nargs = '?'})
end


---
-- Read/Save project
---
local function set(name, state)
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
  return set(name, 'empty')
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

    local parts = vim.split(name, '::')
    if parts[2] then
      name = parts[1]
      branch = parts[2]
    end
  end

  local ok = set(name, 'validate')
  if not ok then
    return
  end

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
  require('local.session').save(name, M.store.dir)
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

  require('local.session').source(name, M.store.dir)

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


---
-- Commands
---
function M.cmd.set(input)
  if input.args == '' then
    local msg = 'Must provide a name for the project folder'
    vim.notify(msg, warn)
    return
  end

  set(input.args, 'validate')
end

function M.cmd.create(input)
  if input.args == '' then
    local msg = 'Must provide a name for the project folder'
    vim.notify(msg, warn)
    return
  end

  M.create(input.args)
end

function M.cmd.save_buffers(input)
  local name = input.args == '' and 'current' or input.args
  M.save_buffer_list(name)
end

function M.cmd.read_buffers(input)
  local name = input.args == '' and 'current' or input.args
  M.load_buffer_list(name)
end

function M.cmd.edit_luarc(input)
  local name = input.args == '' and 'rc' or input.args
  local path = join(M.store.dir, name .. '.lua')

  vim.cmd.edit(path)
end

function M.cmd.load(input)
  M.load({name = input.args})
end

function M.cmd.make_session(input)
  local name = input.args == '' and 'Session' or input.args
  M.make_session(name)
end

function M.cmd.browse_store()
  if M.store.current == nil then
    local msg = 'Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  vim.cmd.FileExplorer(M.store.dir)
end

return M


local cmd = {}
local join = vim.fs.joinpath
local command = vim.api.nvim_create_user_command

function cmd.set(input)
  if input.args == '' then
    local msg = 'Must provide a name for the project folder'
    vim.notify(msg, warn)
    return
  end

  require('project').set_store(input.args, 'validate')
end

function cmd.create(input)
  if input.args == '' then
    local msg = 'Must provide a name for the project folder'
    vim.notify(msg, warn)
    return
  end

  require('project').create(input.args)
end

function cmd.save_buffers(input)
  local name = input.args == '' and 'current' or input.args
  require('project').save_buffer_list(name)
end

function cmd.read_buffers(input)
  local name = input.args == '' and 'current' or input.args
  require('project').load_buffer_list(name)
end

function cmd.edit_luarc(input)
  local name = input.args == '' and 'rc' or input.args
  local dir = require('project').store.dir
  local path = join(dir, name .. '.lua')

  vim.cmd.edit(path)
end

function cmd.load()
  require('project').load()
end

function cmd.make_session(input)
  local name = input.args == '' and 'Session' or input.args
  require('project').make_session(name)
end

function cmd.browse_store()
  local store = require('project').store

  if store.current == nil then
    local msg = 'Project folder has not been set'
    vim.notify(msg, warn)
    return
  end

  vim.cmd.FileExplorer(store.dir)
end

command('ProjectCreate', cmd.create, {nargs = '?'})
command('ProjectChange', cmd.set, {nargs = '?'})
command('ProjectStore', cmd.browse_store, {})
command('ProjectLoad', cmd.load, {})

command('ProjectMakeSession', cmd.make_session, {nargs = '?'})
command('ProjectSaveBuffers', cmd.save_buffers, {bang = true, nargs = '?'})
command('ProjectReadBuffers', cmd.read_buffers, {nargs = '?'})
command('ProjectEditConfig', cmd.edit_luarc, {nargs = '?'})


local command = require('bridge').create_excmd

local join = function(...) return table.concat({...}, '/') end

local project_path = join(vim.fn.stdpath('config'),  'projects')
local state = {
  session = false,
  project_lua = nil
}

local start = function()
  require('persistence').setup()
  vim.fn.mkdir(project_path, 'p')
end

local project_name = function(session)
  local file = vim.fn.fnamemodify(session:sub(1, -5), ':t') .. '.lua'
  local path = join(project_path, file)

  return vim.fn.expand(path)
end

local load_project = function(session)
  local path = project_name(session)
  state.session = true
  state.project_lua = path

  if vim.fn.filereadable(path) == 1 then
    dofile(path)
  end
end

command('SessionStart', function()
  start()
  state.session = true
  state.project_lua = project_name(require('persistence').get_current())
end)

command('SessionStop', function()
  require('persistence').stop()
  state.project_lua = nil
  state.session = nil
end)

command('SessionLoad', function()
  start()

  local persistence = require('persistence')
  persistence.load()
  local session = persistence.get_current()

  if session == nil then return end

  load_project(session)
end)

command('SessionLast', function()
  start()

  local persistence = require('persistence')
  persistence.load({last = true})
  local session = persistence.get_last()

  if session == nil then return end

  load_project(session)
end)

command('SessionEditConfig', function()
  if state.session then
    vim.cmd('edit ' .. vim.fn.fnameescape(state.project_lua))
  end
end)


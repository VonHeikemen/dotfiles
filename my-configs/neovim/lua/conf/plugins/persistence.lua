local autocmd = require('bridge').augroup('persistence_cmds')
local command = require('bridge').create_excmd

local join = function(...) return table.concat({...}, '/') end

local prefix = vim.fn.stdpath('data')
local project_path = join(prefix,  'projects')
local session_path = join(prefix,  'sessions/')

vim.g.session_path = session_path

local state = {
  session = false,
  project_lua = nil
}

local start = function()
  require('persistence').setup({dir = session_path})
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
  require('persistence').load()
end)

command('SessionLast', function()
  start()
  require('persistence').load({last = true})
end)

command('SessionEditConfig', function()
  if not state.session then return end

  if vim.fn.isdirectory(project_path) == 0 then
    vim.fn.mkdir(project_path, 'p')
  end

  vim.cmd('edit ' .. vim.fn.fnameescape(state.project_path))
end)

autocmd('SessionLoadPost', function()
  load_project(vim.v.this_session)
end)


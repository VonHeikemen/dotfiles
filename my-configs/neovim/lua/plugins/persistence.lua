local autocmd = require('bridge').augroup('persistence_cmds')
local command = require('bridge').create_excmd

local join = function(...) return table.concat({...}, '/') end

local prefix = vim.fn.stdpath('data')
local session_path = join(prefix,  'sessions/')

vim.g.session_path = session_path

local start = function()
  require('persistence').setup({dir = session_path})
end

command('SessionStart', function()
  start()
end)

command('SessionStop', function()
  require('persistence').stop()
end)

command('SessionLoad', function()
  start()
  require('persistence').load()
end)

command('SessionLast', function()
  start()
  require('persistence').load({last = true})
end)

autocmd('SessionLoadPost', function()
  require('project-settings').load()
end)


local command = vim.api.nvim_create_user_command

local join = function(...) return table.concat({...}, '/') end

local prefix = vim.fn.stdpath('data')
local session_path = join(prefix,  'sessions/')

vim.g.session_path = session_path

local start = function()
  require('persistence').setup({dir = session_path})
end

local load_session = function(args)
  require('project-settings').load()
  require('persistence').load(args)
end

command('SessionStart', start, {})

command('SessionStop', function() require('persistence').stop() end, {})

command('SessionLoad', function()
  start()
  load_session({last = false})
end, {})

command('SessionLast', function()
  start()
  load_session({last = true})
end, {})


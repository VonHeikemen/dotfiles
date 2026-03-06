require('plugin-specs').commands()

local later = function(callback)
  return vim.defer_fn(callback, 10)
end

local emit = function(event, pattern)
  return function()
    vim.api.nvim_exec_autocmds(event, {
      pattern = pattern,
      modeline = false,
    })
  end
end

later(emit('User', 'SpecDefer'))

if vim.fn.argc(-1) > 0 then
  emit('User', 'LazySpec')()
else
  later(emit('User', 'LazySpec'))
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = require('plugin-specs.state').augroup

autocmd('InsertEnter', {
  once = true,
  group = augroup,
  desc = 'Ensure InsertEnter autocommands',
  callback = function()
    later(emit('InsertEnter'))
  end
})

local vim_edit = 0
autocmd({'BufNew', 'BufNewFile', 'BufReadPre', 'ModeChanged'}, {
  once = true,
  group = augroup,
  desc = 'Emit SpecVimEdit event',
  callback = function()
    if vim_edit == 1 then
      return
    end

    emit('User', 'SpecVimEdit')()
    vim_edit = 1
  end
})


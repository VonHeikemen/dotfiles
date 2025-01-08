local specs = require('mini-specs')

specs.commands()

if type(vim.g.mini_specs) ~= 'table' then
  return
end

specs.setup(vim.g.mini_specs)

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

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  group = specs.augroup,
  desc = 'Ensure InsertEnter autocommands',
  callback = function()
    later(emit('InsertEnter'))
  end
})


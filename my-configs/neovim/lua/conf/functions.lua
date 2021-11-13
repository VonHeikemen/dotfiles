local M = {}

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.not_ok = function(module)
  local ok = pcall(require, module)
  return not ok
end

M.toggle_opt = function(prop, scope, on, off)
  if on == nil then
    on = true
  end

  if off == nil then
    off = false
  end

  if scope == nil then
    scope = 'o'
  end

  return function()
    if vim[scope][prop] == on then
      vim[scope][prop] = off
    else
      vim[scope][prop] = on
    end
  end
end

M.get_selection = function()
  local f = vim.fn
  local temp = f.getreg('s')
  vim.cmd('normal! gv"sy')

  f.setreg('/', f.escape(f.getreg('s'), '/'):gsub('\n', '\\n'))

  f.setreg('s', temp)
end

M.job_output = function(cid, data, name)
  for i, val in pairs(data) do
    print(val)
  end
end

M.nvim_ready = function(fn)
  local b = require 'bridge'
  local exec = function() vim.defer_fn(fn ,10) end

  if type(fn) == 'string' then
    exec = function() require(fn) end
  end

  b.group_command('user_cmds', {'VimEnter', once = true}, exec)
end

return M


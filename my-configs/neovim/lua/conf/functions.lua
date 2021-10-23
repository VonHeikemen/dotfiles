local M = {}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.t = t

M.not_ok = function(module)
  local ok = pcall(require, module)
  return not ok
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

M.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t'<C-n>'
  elseif require('luasnip').expand_or_jumpable() then
    return t'<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t'<Tab>'
  else
    return vim.call('compe#complete')
  end
end

M.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t'<C-p>'
  elseif require('luasnip').jumpable(-1) then
    return t'<Plug>luasnip-jump-prev'
  else
    return t'<S-Tab>'
  end
end

M.completion_up = function(fallback) 
  return function()
    if vim.fn.pumvisible() == 1 then
      return t'<C-p>'
    else
      return fallback
    end
  end
end

M.completion_down = function(fallback)
  return function()
    if vim.fn.pumvisible() == 1 then
      return t'<C-n>'
    else
      return fallback
    end
  end
end

M.toggle_completion = function() 
  if vim.fn.pumvisible() == 1 then
    return vim.call('compe#confirm', t'<Space>')
  else
    return vim.call('compe#complete')
  end
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


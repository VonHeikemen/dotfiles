local bridge = require 'bridge'

local M = {}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.t = t

local check_back_space = function()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    return true
  else
    return false
  end
end

M.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t'<C-n>'
  elseif require 'luasnip'.expand_or_jumpable() then
    return t'<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t'<Tab>'
  else
    return vim.fn["compe#complete"]()
  end
end

M.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t'<C-p>'
  elseif require 'luasnip'.jumpable(-1) then
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
    return vim.fn['compe#confirm'](t'<Space>')
  else
    return vim.fn['compe#complete']()
  end
end

M.autocmd = function(event, fn)
  bridge.group_command('user_cmds', event, fn)
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
  vim.cmd [[
    let temp = @s
    normal! gv"sy
    let @/ = substitute(escape(@s, '\/'), '\n', '\\n', 'g')
    let @s = temp
  ]]
end

M.lightspeed = function (char)
  return function()
    local reg = vim.fn.reg_recording() .. vim.fn.reg_executing()
    if reg == '' then
      local plug = '<Plug>Lightspeed_' .. char
      return t(plug)
    else
      return char
    end
  end
end

return M


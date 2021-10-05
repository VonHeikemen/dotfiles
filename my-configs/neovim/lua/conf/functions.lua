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

M.use_fzf = function()
  local k = vim.keymap

  -- Show key bindings list
  k.nnoremap {'<Leader>?', ':Maps<CR>'}

  -- Search pattern
  k.nnoremap {'<Leader>F', ':Rg<Space>'}
  k.xnoremap {'<Leader>F', ':<C-u>GetSelection<CR>:Rg<Space><C-R>/'}

  -- Find files by name
  k.nnoremap {'<Leader>f', ':FZF<Space>'}
  k.nnoremap {'<Leader>ff', ':FZF<CR>'}

  -- Search symbols in buffer
  k.nnoremap {'<Leader>fs', ':BTags<CR>'}

  -- Search symbols in workspace
  k.nnoremap {'<Leader>fS', ':Tags<CR>'}

  -- Go to definition (using tags)
  k.nnoremap {'gd', ':FZFTags<CR>'}

  -- Search in files history
  k.nnoremap {'<Leader>fh', ':History<CR>'}

  -- Search in active buffers list
  k.nnoremap {'<Leader>bb', ':Buffers<CR>'}
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


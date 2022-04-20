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

M.trailspace_trim = function()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)

  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end

M.smart_buffer_picker = function()
  vim.keymap.set('n','<Leader>bb', function()
    require('telescope.builtin').buffers({only_cwd = vim.fn.haslocaldir() == 1})
  end)

  vim.keymap.set('n','<Leader>B', function()
    require('telescope.builtin').buffers({only_cwd = false})
  end)
end

M.job_output = function(cid, data, name)
  for i, val in pairs(data) do
    print(val)
  end
end

M.nvim_ready = function(fn)
  local autocmd = vim.api.nvim_create_autocmd
  local augroup = vim.api.nvim_create_augroup('user_cmds', {clear = false})

  local delay = 10
  local exec = function() vim.defer_fn(fn , delay) end

  if type(fn) == 'string' then
    local get_module = function() require(fn) end
    exec = function() vim.defer_fn(get_module, delay) end
  end

  autocmd('VimEnter', {once = true, group = augroup, callback = exec})
end

M.edit_macro = function()
  local register = 'i'

  local opts = {default = vim.g.edit_macro_last or ''}

  if opts.default == '' then
    opts.prompt = 'Create Macro'
  else
    opts.prompt = 'Edit Macro'
  end

  vim.ui.input(opts, function(value)
    if value == nil then return end

    local macro = vim.fn.escape(value, '"')
    vim.cmd(string.format('let @%s="%s"', register, macro))

    vim.g.edit_macro_last = value
  end)
end

M.file_explorer = function(cwd)
  if vim.o.lines > 17 then
    require('lir.float').toggle(cwd)
  else
    vim.cmd('edit ' .. (cwd or vim.fn.expand('%:p:h')))
  end
end

M.set_autoindent = function()
  require('guess-indent').setup({auto_cmd = true, verbose = 1})

  vim.defer_fn(function()
    local bufnr = vim.fn.bufnr()
    vim.cmd('silent! bufdo GuessIndent')
    vim.cmd('buffer ' .. bufnr)
  end, 3)
end

return M


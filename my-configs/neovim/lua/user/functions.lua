local M = {}

function M.toggle_opt(prop, scope, on, off)
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

function M.get_selection()
  local f = vim.fn
  local temp = f.getreg('s')
  vim.cmd('normal! gv"sy')

  f.setreg('/', f.escape(f.getreg('s'), '/'):gsub('\n', '\\n'))

  f.setreg('s', temp)
end

function M.syntax_query()
  local f = vim.fn
  local stack = f.synstack(f.line('.'), f.col('.'))

  if stack[1] == nil then
    print('No id found')
    return
  end

  for _, id in pairs(stack) do
    print(f.synIDattr(id, 'name'))
  end
end

function M.trailspace_trim()
  -- Save cursor position to later restore
  local curpos = vim.api.nvim_win_get_cursor(0)

  -- Search and replace trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.api.nvim_win_set_cursor(0, curpos)
end

function M.job_output(cid, data, name)
  for i, val in pairs(data) do
    print(val)
  end
end

function M.edit_macro()
  local register = 'i'

  local opts = {default = vim.g.edit_macro_last or ''}

  if opts.default == '' then
    opts.prompt = 'Create Macro'
  else
    opts.prompt = 'Edit Macro'
  end

  vim.ui.input(opts, function(value)
    if value == nil then
      return
    end

    local macro = vim.fn.escape(value, '"')
    vim.cmd(string.format('let @%s="%s"', register, macro))

    vim.g.edit_macro_last = value
  end)
end

function M.file_explorer(cwd)
  if vim.o.lines > 17 then
    require('lir.float').toggle(cwd)
  else
    vim.cmd({cmd = 'edit', args = {cwd or vim.fn.expand('%:p:h')}})
  end
end

function M.set_autoindent()
  require('guess-indent').setup({auto_cmd = true, verbose = 1})

  vim.defer_fn(function()
    local bufnr = vim.fn.bufnr()
    vim.cmd('silent! bufdo GuessIndent')
    vim.cmd({cmd = 'buffer', args = {bufnr}})
  end, 3)
end

function M.load_project()
  require('project-settings').load({})
  require('plugins.session').load_current(vim.g.session_name)
end

return M


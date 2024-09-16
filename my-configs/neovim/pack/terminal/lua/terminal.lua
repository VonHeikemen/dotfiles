local M = {}
local s = {}

M.shell_ids = {}

function M.toggle_shell(opts)
  opts = opts or {}

  if opts.name == nil then
    local msg = '[terminal] Provide a name for the shell window'
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  local state = M.shell_ids[opts.name] 

  if state == nil then
    state = {}
    state.name = opts.name

    M.shell_ids[opts.name] = state
  end

  if state.buffer == nil then
    s.create_shell(state, opts)
  elseif state.opened then
    s.hide_shell(state, opts)
  else
    s.show_shell(state, opts)
  end
end

function M.float_term(opts)
  opts = opts or {}
  local cmd = opts.cmd or ''
  local win = s.new_float()

  win:mount()

  if cmd == '' then
    vim.cmd('terminal')
    return
  end

  local on_exit = function()
    win:unmount()
  end

  vim.fn.termopen(cmd, {on_exit = on_exit})
end

function M.tabnew(opts)
  opts = opts or {}
  local cmd = opts.cmd or ''
  local win = s.new_tab()

  if cmd == '' then
    vim.cmd('terminal')
    return
  end

  local on_exit = function()
    pcall(vim.api.nvim_win_close, win.winid, 0)
    pcall(vim.api.nvim_buf_delete, win.bufnr, {force = false})
  end

  vim.fn.termopen(cmd, {on_exit = on_exit})
end

function s.create_shell(state, opts)
  opts = opts or {}

  local display = opts.display
  local win = {}

  if display == 'split' then
    win = s.new_split(opts)
    state.split = win
    win:mount()
  elseif display == 'float' then
    win = s.new_float(opts)
    state.fterm = win
    win:mount()
  elseif display == 'tab' then
    win = s.new_tab(opts)
  end

  if win.bufnr == nil then
    return
  end

  vim.api.nvim_win_call(win.winid, function()
    vim.cmd('terminal')
    state.opened = true
  end)

  state.winid = win.winid
  state.buffer = win.bufnr
end

function s.show_shell(state, opts)
  opts = opts or {}
  local display = opts.display

  if display == 'split' then
    if state.split == nil then
      return
    end

    state.split:show()
    state.opened = true
  elseif display == 'float' then
    if state.fterm == nil then
      return
    end

    state.fterm:show()
    state.opened = true
  elseif display == 'tab' then
    s.new_tab()
    state.opened = true
  end
end

function s.hide_shell(state, opts)
  opts = opts or {}
  local display = opts.display

  if display == 'split' then
    if state.split == nil then
      return
    end

    state.split:hide()
    state.opened = false
  elseif display == 'float' then
    if state.fterm == nil then
      return
    end

    state.fterm:hide()
    state.opened = false
  elseif display == 'tab' then
    pcall(vim.api.nvim_win_close, state.winid, 0)
    state.opened = false
  end
end

function s.new_tab(opts)
  local ok = pcall(vim.cmd, 'tabnew')

  if not ok then
    return {}
  end

  return {
    winid = vim.api.nvim_get_current_win(),
    bufnr = vim.api.nvim_get_current_buf(),
  }
end

function s.new_split(opts)
  local Split = require("nui.split")
  local position = opts.direction or 'bottom'
  local size = opts.size or '30%'

  return Split({
    relative = 'editor',
    position = position,
    size = size,
  })
end

function s.new_float(opts)
  local Popup = require('nui.popup')

  local position = {
    row = '25%',
    col = '50%',
  }

  local size = {
    width = '70%',
    height = '70%',
  }

  return Popup({
    position = position,
    size = size,
    relative = 'editor',
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
    },
  })
end

return M


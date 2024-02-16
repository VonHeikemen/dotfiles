local M = {}
local s = {}
local uv = vim.loop or vim.uv

M.window = nil
s.mounted = false
s.augroup = vim.api.nvim_create_augroup('buffernav_cmds', {clear = true})

function M.setup()
  M.plugin()

  s.save_keymap = '<leader>w'
  vim.keymap.set('n', 'M', '<cmd>BufferNavMenu<cr>')
  vim.keymap.set('n', '<leader>m', '<cmd>BufferNavMark<cr>')
  vim.keymap.set('n', '<leader>M', '<cmd>BufferNavMark!<cr>')
  vim.keymap.set('n', '<M-1>', '<cmd>BufferNav 1<cr>')
  vim.keymap.set('n', '<M-2>', '<cmd>BufferNav 2<cr>')
  vim.keymap.set('n', '<M-3>', '<cmd>BufferNav 3<cr>')
  vim.keymap.set('n', '<M-4>', '<cmd>BufferNav 4<cr>')
end

function M.plugin()
  local command = vim.api.nvim_create_user_command
  local autocmd = vim.api.nvim_create_autocmd

  command('BufferNav', s.buffer_nav, {nargs = 1})
  command('BufferNavMenu', M.show_menu, {})
  command('BufferNavMark', s.add_file, {bang = true})
  command('BufferNavRead', s.read_content, {nargs = 1, complete = 'file'})
  command('BufferNavSave', s.save_content, {nargs = '?', complete = 'file'})

  autocmd('FileType', {
    pattern = 'BufferNav',
    group = s.augroup,
    callback = M.after_mount
  })
end

function M.after_mount(event)
  if M.window == nil then
    return
  end

  local window = M.window

  local close = function() window:hide() end

  local accept = function()
    local index = vim.fn.line('.')
    close()
    M.go_to_file(index)
  end

  local resize = function(e)
    if M.window and M.window.bufnr == e.buf then
      close()
    end

    M.window:update_layout({position = position, size = size})
  end

  local opts = {buffer = event.buf}
  vim.keymap.set('n', '<esc>', close, opts)
  vim.keymap.set('n', 'q', close, opts)
  vim.keymap.set('n', '<C-c>', close, opts)

  vim.keymap.set('n', s.save_keymap, '<cmd>BufferNavSave<cr>', opts)

  vim.keymap.set('n', '<cr>', accept, opts)
  vim.keymap.set('n', '<M-b>', accept, opts)

  vim.api.nvim_create_autocmd('BufLeave', {
    group = s.augroup,
    buffer = event.buf,
    once = true,
    callback = close,
  })

  vim.api.nvim_create_autocmd('VimResized', {
    group = s.augroup,
    buffer = event.buf,
    callback = resize,
  })
end

function M.show_menu()
  if M.window == nil then
    M.window = s.create_window()
  end

  if s.mounted then
    M.window:show()
  else
    M.window:mount()
    s.mounted = true
  end
end

function s.add_file(input)
  local name = vim.fn.bufname('%')
  local should_mount = M.window == nil

  if should_mount then
    M.window = s.create_window()
  end

  local start_row = vim.api.nvim_buf_line_count(M.window.bufnr)
  local end_row = start_row

  if start_row == 1 then
    local line = vim.api.nvim_buf_get_lines(M.window.bufnr, 0, 1, true)
    if vim.trim(line[1]) == '' then
      start_row = 0
    end
  end

  vim.api.nvim_buf_set_lines(
    M.window.bufnr,
    start_row,
    end_row,
    false,
    {vim.fn.fnamemodify(name, ':.')}
  )

  if input.bang == false then
    return
  end

  if should_mount then
    M.window:mount()
    s.mounted = true
  else
    M.window:show()
  end
end

function M.go_to_file(index)
  if M.window == nil then
    return
  end

  local count = vim.api.nvim_buf_line_count(M.window.bufnr)

  if index > count then
    return
  end

  local path = vim.api.nvim_buf_get_lines(
    M.window.bufnr,
    index - 1,
    index,
    false
  )[1]

  if path == nil then
    return
  end

  if vim.fn.bufloaded(path) == 1 then
    vim.cmd.buffer(path)
    return
  end

  if uv.fs_stat(path) then
    vim.cmd.edit(path)
  end
end

function M.load_content(path)
  if M.window then
    M.window:unmount()
    s.filepath = nil
  end

  local window = s.create_window()
  vim.api.nvim_buf_call(window.bufnr, function()
    vim.cmd.read(path)
    s.filepath = path
    vim.api.nvim_buf_set_lines(window.bufnr, 0, 1, false, {})
  end)

  M.window = window
end

function s.create_window()
  local Popup = require('nui.popup')
  local position = {
    row = '20%',
    col = '50%',
  }
  local size = {
    width = '50%',
    height = '30%',
  }

  local window = Popup({
    position = position,
    size = size,
    relative = 'editor',
    enter = true,
    focusable = true,
    border = {
      style = 'rounded',
      text = {top = '[Buffers]'}
    },
    buf_options = {
      filetype = 'BufferNav'
    },
    win_options = {
      number = true,
      cursorline = vim.o.cursorline,
    },
  })

  s.mounted = false

  return window
end

function s.buffer_nav(input)
  local index = tonumber(input.args)
  if index == nil then
    return
  end

  M.go_to_file(index)
end

function s.read_content(input)
  local path = input.args
  if path == nil then
    return
  end

  M.load_content(path)
end

function s.save_content(input)
  if vim.bo.filetype ~= 'BufferNav' then
    return
  end

  local path = input.args

  if path == '' then
    path = s.filepath
  end

  if path == nil then
    vim.notify('Must provide a filepath', vim.log.levels.WARN)
    return
  end

  s.filepath = path
  vim.cmd.write({args = {path}, bang = true})
end

return M


local M = {}
local s = {}
local uv = vim.uv

M.window = nil
s.mounted = false
s.augroup = 'buffernav_cmds'
s.last_buf = {}
s.last_buf_autocmd = 0

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

  if vim.g.buffer_nav_save then
    vim.keymap.set('n', vim.g.buffer_nav_save, '<cmd>BufferNavSave<cr>', opts)
  end

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
    local new_window = s.create_window()
    if new_window == nil then
      return
    end

    M.window = new_window
  elseif M.window.bufnr == nil and s.filepath then
    M.load_content(s.filepath)
  end

  if s.mounted then
    M.window:show()
  else
    M.window:mount()
    s.mounted = true
  end
end

function M.add_file(opts)
  opts = opts or {}
  local name = vim.fn.bufname('%')
  local show_buffers = opts.show_buffers == true

  if M.window == nil then
    M.window = s.create_window()
  elseif M.window.bufnr == nil then
    if s.filepath then
      M.load_content(s.filepath)
    end
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

  if show_buffers == false then
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
  local ok, Popup = pcall(require, 'nui.popup')

  if not ok then
    vim.notify('module "nui.poup" not found', vim.log.levels.WARN)
    return
  end

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

function s.short_name(arg, prefix)
  local name = vim.fn.fnamemodify(arg, ':t')
  local dir = vim.fs.dirname(arg)
  if dir then
    name = string.format('%s%s/%s', prefix, vim.fn.fnamemodify(dir, ':t'), name)
  end

  return name
end

function M.save_content(path)
  if vim.bo.filetype ~= 'BufferNav' then
    return
  end

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

function M.go_to_last_buf()
  if s.last_buf[1] then
    vim.cmd.buffer(s.last_buf[1])
  else
    vim.notify('No recent buffer saved')
  end
end

function M.update_last_buf()
  if M.window == nil then
    return
  end

  local current = vim.api.nvim_get_current_buf()
  local list = vim.api.nvim_buf_get_lines(M.window.bufnr, 0, 3, false)

  local in_list = false
  for i, item in ipairs(list) do
    local bufnr = vim.fn.bufnr(item)

    if current == bufnr then
      in_list = true
    end
  end

  if not in_list then
    local name = vim.fn.bufname(current)
    if name ~= '' then
      s.last_buf = {current, name}
    end
  end
end

function M.picker()
  if M.window == nil then
    return
  end

  local ok, Menu = pcall(require, 'nui.menu')
  if not ok then
    vim.notify('module "nui.menu" not found', vim.log.levels.WARN)
    return
  end

  local current = vim.api.nvim_get_current_buf()
  local list = vim.api.nvim_buf_get_lines(M.window.bufnr, 0, 3, false)
  local in_list = false
  local options = {}
  local cursor = 0

  for i, item in ipairs(list) do
    local bufnr = vim.fn.bufnr(item)
    local state = '* '

    if current == bufnr then
      in_list = true
      state = '% '
      cursor = i
    end

    local name = s.short_name(item, state)
    local cmd = string.format('BufferNav %s', i)
    options[i] = Menu.item(name, {cmd = cmd})
  end

  if not in_list then
    local name = vim.fn.bufname(current)
    if name ~= '' then
      s.last_buf = {current, name}
    end
  end

  if s.last_buf[1] then
    local name
    local cmd = string.format('buffer %s', s.last_buf[1])

    if in_list then
      name = s.short_name(s.last_buf[2], '* ')
    else
      name = s.short_name(s.last_buf[2], '% ')
      cursor = #options + 1
    end

    table.insert(options, Menu.item(name, {cmd = cmd}))
  end

  local menu = Menu({
    position = {
      row = '15%',
      col = '50%',
    },
    size = {
      width = '35%',
      height = 4,
    },
    border = {
      style = 'rounded',
      text = {
        top = '[Buffers]',
        top_align = 'center',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:Normal',
    },
  }, {
    lines = options,
    keymap = {
      focus_next = {'j', '<Down>', '<Tab>'},
      focus_prev = {'k', '<Up>', '<S-Tab>'},
      close = {'<Esc>', '<C-c>', 'q'},
      submit = {'<CR>', '<Space>'},
    },
    on_submit = function(item)
      vim.cmd(item.cmd)
    end,
  })

  menu:mount()
  local key_opts = {buffer = menu.bufnr, nowait = true, remap = true}
  vim.wo.number = true

  vim.keymap.set('n', '1', 'gg<cr>', key_opts)
  vim.keymap.set('n', '2', '2gg<cr>', key_opts)
  vim.keymap.set('n', '3', '3gg<cr>', key_opts)

  if options[4] then
    vim.keymap.set('n', '4', '4gg<cr>', key_opts)
  end

  vim.keymap.set('n', 'e', function()
    menu:unmount()
    vim.cmd('BufferNavMenu')
  end, key_opts)

  if cursor > 0 then
    vim.api.nvim_win_set_cursor(0, {cursor, 0})
  end

  menu:on('BufLeave', function()
    menu:unmount()
  end)

  if s.last_buf_autocmd == 0 then
    s.last_buf_autocmd = vim.api.nvim_create_autocmd('BufEnter', {
      group = s.augroup,
      callback = M.update_last_buf,
    })
  end
end

return M


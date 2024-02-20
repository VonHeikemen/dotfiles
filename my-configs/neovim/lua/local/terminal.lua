local M = {}
local s = {}

s.current = {
  buffer = nil,
  opened = false,
}

s.config = {
  direction = 'bottom',
  size = 0.25,
  on_open = function(_) return 1 end
}

function M.setup()
  vim.keymap.set({'n', 'i', 'x', 't'}, '<M-i>', '<cmd>Term<cr>')

  vim.keymap.set('t', '<C-o>w', '<C-\\><C-n><C-w>w')
  vim.keymap.set('t', '<C-o>h', '<C-\\><C-n><C-w>h')
  vim.keymap.set('t', '<C-o>k', '<C-\\><C-n><C-w>k')
  vim.keymap.set('t', '<C-o>j', '<C-\\><C-n><C-w>j')
  vim.keymap.set('t', '<C-o>l', '<C-\\><C-n><C-w>l')

  vim.keymap.set('t', '<C-o>t', '<C-\\><C-n>gt')
  vim.keymap.set('t', '<C-o>T', '<C-\\><C-n>gT')

  local on_open = function()
    vim.w.status_style = 'short'
    vim.wo.statusline = require('local.statusline').get_status('short')

    local hl_term = vim.api.nvim_get_hl(0, {name = 'TermBg'})
    if hl_term.bg then
      vim.wo.winhighlight = 'Normal:TermBg,SignColumn:TermBg'
    end
  end

  local toggleterm = function()
    local env = require('user.env')

    if vim.o.lines < env.small_screen_lines then
      M.toggle({size = 0.4, direction = 'right'})
      return
    end

    M.toggle({size = 0.3, direction = 'bottom'})
  end

  vim.api.nvim_create_user_command('Term', toggleterm, {})

  M.plugin({on_open = on_open})
end

function M.plugin(opts)
  local augroup = vim.api.nvim_create_augroup('term_cmds', {clear = true})
  local autocmd = vim.api.nvim_create_autocmd

  M.settings(opts)

  autocmd('BufEnter', {
    group = augroup,
    pattern = 'term://*',
    command = 'startinsert'
  })
  autocmd('TermOpen', {
    group = augroup,
    callback = function(event)
      vim.opt_local.swapfile = false
      vim.opt_local.buflisted = false
      vim.opt_local.modified = false
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false

      vim.cmd('startinsert')

      if s.current.buffer == nil then
        s.current.buffer = event.buf
        s.current.opened = true
      end

      if type(s.config.on_open) == 'function' then
        s.config.on_open(event)
      end
    end
  })
  autocmd('TermClose', {
    group = augroup,
    nested = true,
    callback = function(event)
      if event.buf ~= s.current.buffer then
        return
      end

      if vim.v.event.status == 0
        and vim.api.nvim_buf_is_valid(s.current.buffer)
      then
        pcall(vim.api.nvim_win_close, vim.fn.bufwinid(s.current.buffer), true)
        pcall(vim.api.nvim_buf_delete, s.current.buffer, {force = true})
      end

      s.current.buffer = nil
      s.current.opened = false
    end
  })
end

function M.settings(opts)
  if type(opts) == 'table' then
    s.config = vim.tbl_deep_extend('force', s.config, opts)
  end
end

function M.toggle(opts)
  opts = opts or {}
  if s.current.buffer == nil then
    s.create_terminal(opts)
  elseif s.current.opened then
    M.hide_terminal()
  else
    M.show_terminal(opts)
  end
end

function s.create_terminal(opts)
  opts = opts or {}
  local direction = opts.direction or s.config.direction
  local size = opts.size or s.config.size

  s.make_split({direction = direction, size = size})
  vim.cmd('terminal')
end

function M.show_terminal(opts)
  opts = opts or {}

  local direction = opts.direction or s.config.direction
  local size = opts.size or s.config.size

  if type(s.current.buffer) ~= 'number' then
    s.create_terminal(opts)
    return
  end

  s.make_split({direction = direction, size = size})
  vim.api.nvim_win_set_buf(0, s.current.buffer)
  s.current.opened = true
end

function M.hide_terminal()
  local win_term = vim.fn.bufwinid(s.current.buffer)
  if win_term == -1 then
    return
  end

  pcall(vim.api.nvim_win_close, win_term, 0)
  s.current.opened = false
end

function s.make_split(opts)
  opts = opts or {}
  local size = opts.size or 0.25

  local exec = {
    range = {},
    cmd = 'split',
    mods = {
      silent = true,
      keepalt = true,
      vertical = false,
    }
  }

  if opts.direction == 'bottom' then
    exec.mods.vertical = false
    exec.mods.split = 'botright'
  elseif opts.direction == 'right' then
    exec.mods.vertical = true
    exec.mods.split = 'botright'
  elseif opts.direction == 'top' then
    exec.mods.vertical = false
    exec.mods.split = 'topleft'
  elseif opts.direction == 'left' then
    exec.mods.vertical = true
    exec.mods.split = 'topleft'
  end

  if exec.mods.vertical then
    exec.range[1] = vim.fn.float2nr(size * math.floor(vim.o.columns - 2))
  else
    exec.range[1] = vim.fn.float2nr(size * math.floor(vim.o.lines - 2))
  end

  vim.cmd(exec)
end

return M


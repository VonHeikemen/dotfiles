local augroup = vim.api.nvim_create_augroup('term_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd

autocmd('BufEnter', {
  group = augroup,
  pattern = 'term://*',
  command = 'startinsert'
})

autocmd('TermOpen', {
  group = augroup,
  callback = function(event)
    local state = require('terminal').state

    vim.opt_local.swapfile = false
    vim.opt_local.buflisted = false
    vim.opt_local.modified = false
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false

    vim.cmd('startinsert')

    if state.buffer == nil then
      state.buffer = event.buf
      state.opened = true
    end

    local config = require('terminal.settings').current

    if type(config.on_open) == 'function' then
      config.on_open(event)
    end
  end
})

autocmd('TermClose', {
  group = augroup,
  nested = true,
  callback = function(event)
    local state = require('terminal').state

    if event.buf ~= state.buffer then
      return
    end

    if vim.v.event.status == 0
      and vim.api.nvim_buf_is_valid(state.buffer)
    then
      pcall(vim.api.nvim_win_close, vim.fn.bufwinid(state.buffer), true)
      pcall(vim.api.nvim_buf_delete, state.buffer, {force = true})
    end

    state.buffer = nil
    state.opened = false
  end
})


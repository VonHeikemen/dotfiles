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
    vim.opt_local.swapfile = false
    vim.opt_local.buflisted = false
    vim.opt_local.modified = false
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false

    vim.cmd('startinsert')
  end
})

autocmd('TermClose', {
  group = augroup,
  callback = function(event)
    local buf = event.buf
    local term = require('terminal')

    local result = vim.tbl_filter(function(win)
      return win.buffer == buf
    end, term.shell_ids)

    if #result == 0 then
      return
    end

    local state = result[1]
    if state.fterm then
      state.fterm:unmount()
    end

    if state.split then
      state.split:unmount()
    end

    term.shell_ids[state.name] = nil
  end
})


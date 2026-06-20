local bufnr = vim.api.nvim_get_current_buf()
local winid = vim.fn.bufwinid(bufnr)

vim.g.quickfix_win = winid

vim.api.nvim_create_autocmd({'WinClosed'}, {
  once = true,
  pattern = tostring(winid),
  command = 'let g:quickfix_win = -1'
})


local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'buffer-nav'
Plugin.dir = vim.fs.joinpath(path, 'pack', Plugin.name)

function Plugin.init()
  vim.g.buffer_nav_save = '<leader>w'
end

function Plugin.config()
  vim.keymap.set('n', 'M', '<cmd>BufferNavMenu<cr>')
  vim.keymap.set('n', '<leader>m', '<cmd>BufferNavMark<cr>')
  vim.keymap.set('n', '<leader>M', '<cmd>BufferNavMark!<cr>')
  vim.keymap.set('n', '<M-1>', '<cmd>BufferNav 1<cr>')
  vim.keymap.set('n', '<M-2>', '<cmd>BufferNav 2<cr>')
  vim.keymap.set('n', '<M-3>', '<cmd>BufferNav 3<cr>')
  vim.keymap.set('n', '<M-4>', '<cmd>BufferNav 4<cr>')
end

return Plugin


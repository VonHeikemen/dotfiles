---
-- Config for local plugins in "pack/core/start/"
---

local env = require('user.env')

vim.g.buffer_nav_save = '<leader>w'
vim.g.project_store_path = env.project_store

vim.g.mini_specs = {
  -- install `mini.deps` if it's missing
  bootstrap = env.bootstrap_plugins,
  -- path to plugin configs
  import_dir = vim.fs.joinpath(
    vim.fn.stdpath('config') --[[@as string]],
    'lua',
    'specs'
  )
}

vim.keymap.set('n', '<leader>de', '<cmd>ProjectStore<cr>')
vim.keymap.set('n', '<leader>dc', '<cmd>ProjectEditConfig<cr>')

vim.keymap.set('n', 'M', '<cmd>BufferNavMenu<cr>')
vim.keymap.set('n', '<leader>m', '<cmd>BufferNavMark<cr>')
vim.keymap.set('n', '<leader>M', '<cmd>BufferNavMark!<cr>')
vim.keymap.set('n', '<M-1>', '<cmd>BufferNav 1<cr>')
vim.keymap.set('n', '<M-2>', '<cmd>BufferNav 2<cr>')
vim.keymap.set('n', '<M-3>', '<cmd>BufferNav 3<cr>')
vim.keymap.set('n', '<M-4>', '<cmd>BufferNav 4<cr>')


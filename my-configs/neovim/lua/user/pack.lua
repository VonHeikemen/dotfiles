---
-- Config for local plugins in "pack/plugins/start/"
---

local env = vim.g.env or {}
local nvim_data = vim.fn.stdpath('data') --[[@as string]]

vim.g.buffer_nav_save = '<leader>w'
vim.g.project_store_path = env.project_store

vim.g.mini_specs = {
  -- path to "pack" directory
  package_path = vim.fs.joinpath(nvim_data, 'site'),
  -- path to plugin configs
  import_dir = vim.fs.joinpath(
    vim.fn.stdpath('config') --[[@as string]],
    'lua',
    'specs'
  )
}

vim.keymap.set('n', '<leader>de', '<cmd>ProjectStore<cr>')
vim.keymap.set('n', '<leader>dc', '<cmd>ProjectEditConfig<cr>')

vim.keymap.set('n', 'so', '<cmd>BufferNavPicker<cr>')
vim.keymap.set('n', 'M', '<cmd>BufferNavMenu<cr>')
vim.keymap.set('n', '<leader>m', '<cmd>BufferNavMark<cr>')
vim.keymap.set('n', '<leader>M', '<cmd>BufferNavMark!<cr>')
vim.keymap.set('n', '<M-1>', '<cmd>BufferNav 1<cr>')
vim.keymap.set('n', '<M-2>', '<cmd>BufferNav 2<cr>')
vim.keymap.set('n', '<M-3>', '<cmd>BufferNav 3<cr>')
vim.keymap.set('n', '<M-4>', '<cmd>BufferNav x<cr>')

if pcall(require, 'mini.deps') then
  -- disable netrw if plugins are installed
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end


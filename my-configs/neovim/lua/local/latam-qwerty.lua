local nx = {'n', 'x'}
local nxo = {'n', 'x', 'o'}
local nxoi = {'n', 'x', 'o', 'i'}
local i = {'i'}

vim.keymap.set(nxo, 'ñ', ';')
vim.keymap.set(nxo, 'Ñ', ':')

vim.keymap.set(nxoi, '·', '#')
vim.keymap.set(nxo, '-', '/')
vim.keymap.set(nxo, 'º', '`')

vim.keymap.set(nx, 'g+', 'g]')
vim.keymap.set(nxo, '<C-+>', '<C-]>')
vim.keymap.set(i, '<C-x><C-+>', '<C-x><C-]>')


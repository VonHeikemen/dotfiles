if vim.g.latam_qwerty == 0 then
  return
end

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
vim.keymap.set(i, '·', '$')

vim.keymap.set(nxo, 'à', '`a')
vim.keymap.set(nxo, 'è', '`e')
vim.keymap.set(nxo, 'ì', '`i')
vim.keymap.set(nxo, 'ò', '`o')
vim.keymap.set(nxo, 'ù', '`u')


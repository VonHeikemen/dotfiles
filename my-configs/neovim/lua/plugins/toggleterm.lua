require('toggleterm').setup({
  on_open = function()
    vim.w.status_style = 'short'
    vim.wo.statusline = require('plugins.statusline').get_status('short')
  end
})

local open_mapping = '<M-i>'

local function toggle()
  local term = require('toggleterm') 

  if vim.o.lines < 17 then
    local size = vim.o.columns * 0.4
    term.toggle(vim.v.count, size, nil, 'vertical')
    return
  end

  local size = vim.o.lines * 0.3
  term.toggle(vim.v.count, size, nil, 'horizontal')
end

vim.keymap.set({'n', 'i', 'x'}, open_mapping, toggle, {desc = 'Toggle terminal'})
vim.keymap.set('t', open_mapping, '<cmd>ToggleTerm<cr>')

vim.keymap.set('n', '<C-w>t', '<cmd>ToggleTerm direction=tab<cr>')
vim.keymap.set('n', '<C-w>f', '<cmd>ToggleTerm direction=float<cr>')
vim.keymap.set('t', '<C-w>t', '<cmd>ToggleTerm<cr><cmd>ToggleTerm direction=tab<cr>')
vim.keymap.set('t', '<C-w>f', '<cmd>ToggleTerm<cr><cmd>ToggleTerm direction=float<cr>')

vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w')
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l')


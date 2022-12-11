local augroup = vim.api.nvim_create_augroup('goyo_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local bind = vim.keymap.set
local unbind = vim.keymap.del

vim.g.goyo_height = '100%'

local function enter()
  vim.opt.wrap = true
  vim.opt.linebreak =  true
  
  bind({'n', 'x'}, 'k', 'gk')
  bind({'n', 'x'}, 'j', 'gj')
  bind('n', 'O', 'O<Enter><Up>')
end

local function leave()
  vim.opt.wrap = false
  vim.opt.linebreak =  false

  unbind({'n', 'x'}, 'k')
  unbind({'n', 'x'}, 'j')
  unbind('n', 'O')
end

autocmd('User', {pattern = 'GoyoEnter', group = augroup, callback = enter})
autocmd('User', {pattern = 'GoyoLeave', group = augroup, callback = leave})

bind('n', '<Leader>uz', '<cmd>Goyo<CR>')


local fns = require('conf.functions')
local autocmd = require('bridge').augroup('mapping_cmds')
local luafn = require('bridge').lua_map

local noremap = function(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, {noremap = true})
end
local remap = function(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, {noremap = false})
end
local bufmap = function(mode, lhs, rhs, opts)
  vim.api.nvim_set_keymap(0, mode, lhs, rhs, opts)
end

-- Leader
vim.g.mapleader = ' '

-- ========================================================================== --
-- ==                             KEY MAPPINGS                             == --
-- ========================================================================== --

-- Enter command mode
noremap('n', '<CR>', ':')

-- Escape to normal mode
noremap('', '<C-L>', '<Esc>')
noremap('i', '<C-L>', '<Esc>')
noremap('t', '<C-L>', '<C-\\><C-n>')
noremap('c', '<C-L>', '<Esc>')

-- Select all text in current buffer
noremap('n', '<Leader>a', 'ggVG')

-- Go to matching pair
remap('n', '<Leader>e', '%')
remap('x','<Leader>e', '%')

-- Go to first character in line
noremap('', '<Leader>h', '^')

-- Go to last character in line
noremap('', '<Leader>l', 'g_')

-- Scroll half page and center
noremap('', '<C-u>', '<C-u>M')
noremap('', '<C-d>', '<C-d>M')

-- Search will center on the line it's found in
noremap('n', 'n', 'nzzzv')
noremap('n', 'N', 'Nzzzv')
noremap('n', '#', '#zz')
noremap('n', '*', '*zz')

-- Better ctrl+h
noremap('s', '<C-h>', '<Space><BS>')
remap('i', '<C-h>', '<BS>')

-- Yank, delete and paste will use the x register
noremap('n', 'y', '"xy')
noremap('x', 'y', '"xy')
noremap('n', 'Y', '"xy$')
noremap('n', 'd', '"xd')
noremap('x', 'd', '"xd')
noremap('n', 'D', '"xD')
noremap('n', 'p', '"xp')
noremap('x', 'p', '"xp')
noremap('n', 'P', '"xP')

-- ========================================================================== --
-- ==                           COMMAND MAPPINGS                           == --
-- ========================================================================== --

-- Moving lines and preserving indentation
noremap('n', '<C-j>', ":move .+1<CR>==")
noremap('n', '<C-k>', ":move .-2<CR>==")
noremap('v', '<C-j>', ":move '>+1<CR>gv=gv")
noremap('v', '<C-k>', ":move '<-2<CR>gv=gv")

-- Write file
noremap('n', '<Leader>w', ':write<CR>')

-- Safe quit
noremap('n', '<Leader>qq', ':quitall<CR>')

-- Force quit
noremap('n', '<Leader>Q', ':quitall!<CR>')

-- Close buffer
noremap('n', '<Leader>bq', ':bdelete<CR>')

-- Move to last active buffer
noremap('n', '<Leader>bl', ':buffer #<CR>')

-- Navigate between buffers
noremap('n', '[b', ':bprevious<CR>')
noremap('n', ']b', ':bnext<CR>')

-- Open new tabpage
noremap('n', '<Leader>tn', ':tabnew<CR>')

-- Navigate between tabpages
noremap('n', '[t', ':tabprevious<CR>')
noremap('n', ']t', ':tabnext<CR>')

-- Clear messages
noremap('n', '<Leader><space>', ":echo ''<CR>")

-- Switch to the directory of the open buffer
noremap('n', '<Leader>cd', ':lcd %:p:h<CR>:pwd<CR>')

-- ========================================================================== --
-- ==                           TOGGLE ELEMENTS                            == --
-- ========================================================================== --

-- Search result highlight
noremap('n', '<Leader>uh', luafn(fns.toggle_opt('hlsearch')))

-- Tabline
noremap('n', '<Leader>ut', luafn(fns.toggle_opt('showtabline', 'o', 1, 0)))

-- Line length ruler
noremap('n', '<Leader>ul', luafn(fns.toggle_opt('colorcolumn', 'wo', '81', '0')))

-- Cursorline highlight
noremap('n', '<Leader>uc', luafn(fns.toggle_opt('cursorline')))

-- Line numbers
noremap('n', '<Leader>un', luafn(fns.toggle_opt('number')))

-- Relative line numbers
noremap('n', '<Leader>ur', luafn(fns.toggle_opt('relativenumber')))

-- ========================================================================== --
-- ==                           SEARCH COMMANDS                            == --
-- ========================================================================== --

-- Show key bindings list
noremap('n', '<Leader>?', ':Telescope keymaps<CR>')

-- Search pattern
noremap('n', '<Leader>F', ':TGrep ')
noremap('x', '<Leader>F', ':<C-u>GetSelection<CR>:TGrep <C-R>/<CR>')
noremap('n', '<Leader>fw', ":TGrep <C-r>=expand('<cword>')<CR><CR>")

-- Find files by name
noremap('n', '<Leader>ff', ':Telescope find_files<CR>')

-- Search symbols in buffer
noremap('n', '<Leader>fs', ':Telescope treesitter<CR>')

-- Search in files history
noremap('n', '<Leader>fh', ':Telescope oldfiles<CR>')

-- Search in active buffers list
noremap('n', '<Leader>bb', ':Telescope buffers<CR>')
noremap('n', '<Leader>B', ':Telescope buffers only_cwd=true<CR>')

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

-- Begin search & replace using the selected text
noremap('n', '<Leader>r', ':%s///gc<Left><Left><Left><Left>')
noremap('x', '<Leader>r', ':s///gc<Left><Left><Left><Left>')
noremap('x', '<Leader>R', ':<C-u>GetSelection<CR>:%s/\\V<C-R>=@/<CR>//gc<Left><Left><Left>')

-- Put selected text in register '/'
noremap('v', '<Leader>y', ':<C-u>GetSelection<CR>gv')
noremap('v', '<Leader>Y', ':<C-u>GetSelection<CR>:set hlsearch<CR>')

-- Close buffer while preserving the layout
noremap('n', '<Leader>bc', ':Bdelete<CR>')

-- Toggle zen-mode
noremap('n', '<Leader>uz', ':ZenMode<CR>')

-- Manage the quickfix list
remap('n', '[q', '<Plug>(qf_qf_previous)zz')
remap('n', ']q', '<Plug>(qf_qf_next)zz')
remap('n', '<Leader>cc', '<Plug>(qf_qf_toggle)')

autocmd({'filetype', 'qf'}, function()
  local opts = {noremap = false}
  -- Go to location under the cursor
  bufmap('n', 'gl', '<CR>', {noremap = true})

  -- Go to next location and stay in the quickfix window
  bufmap('n', 'K', '<Plug>(qf_qf_previous)zz<C-w>w', opts)

  -- Go to previous location and stay in the quickfix window
  bufmap('n', 'J', '<Plug>(qf_qf_next)zz<C-w>w', opts)

  -- Toggle nvim-bqf
  bufmap('n', 'p', ':BqfEnable<CR>', opts)
  bufmap('n', 'P', ':BqfDisable<CR>', opts)

  bufmap('n', '<leader>r', ':%s///g<Left><Left>', opts)
end)

-- Open file manager
noremap('n', '<leader>dd', ":lua require('lir.float').toggle()<CR>")
noremap('n', '<leader>da', ":lua require('lir.float').toggle(vim.fn.getcwd())<CR>")
noremap('n', '-', ":exe 'edit' expand('%:p:h')<CR>")
noremap('n', '_', ":exe 'edit' getcwd()<CR>")

-- Undo break points
local break_points = {'<Space>', '-', '_', ':', '.', '/'}
for _, char in ipairs(break_points) do
  noremap('i', char, char .. '<C-g>u')
end


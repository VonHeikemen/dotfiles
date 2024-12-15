-- Bind options
local bind = vim.keymap.set
local remap = {remap = true}

-- Leader
vim.g.mapleader = ' '

-- ========================================================================== --
-- ==                             KEY MAPPINGS                             == --
-- ========================================================================== --

-- Escape to normal mode
bind('', '<M-l>', '<Esc>')
bind('t', '<M-l>', '<C-\\><C-n>')
bind('c', '<M-l>', '<Esc>')
bind('i', '<M-l>', '<Esc>')

-- Basic clipboard interaction
bind({'n', 'x', 'o'}, 'gy', '"+y')
bind({'n', 'x', 'o'}, 'gp', '"+p')

-- Comfy enter
bind('n', '<M-b>', '<Enter>')
bind('i', '<M-b>', '<Enter>')

-- Redo
bind('n', 'U', '<C-r>')

-- Select all text in current buffer
bind('n', '<leader>a', '<cmd>keepjumps normal! ggVG<cr>')

-- Go to matching pair
bind({'n', 'x'}, '<leader>e', '%', remap)

-- Go to first character in line
bind('', '<leader>h', '^')

-- Go to last character in line
bind('', '<leader>l', 'g_')

-- Scroll half page and center
bind('n', '<M-k>', '<C-u>M')
bind('n', '<M-j>', '<C-d>M')

-- Search will center on the line it's found in
bind('n', 'n', 'nzzzv')
bind('n', 'N', 'Nzzzv')
bind('n', '#', '#zz')
bind('n', '*', '*zz')

-- Delete in select mode
bind('s', '<BS>', '<C-g>"_c')
bind('s', '<M-h>', '<BS>', remap)

-- Because of reasons
bind('i', '<M-h>', '<BS>', remap)
bind('s', '<Space>', '<BS>', {remap = true, nowait = true})

bind({'i', 'c'}, '<M-a>', '<Left>')
bind({'i', 'c'}, '<M-d>', '<Right>')
bind('i', '<M-Space>', '<Enter><Up><Esc>o')

-- Whatever you delete, make it go away
bind({'n', 'x'}, 'c','"_c')
bind('n', 'C','"_C')
bind('x', 'C', '"_c')

bind({'n', 'x'}, 'x','"_x')
bind({'n', 'x'}, 'X','"_d')

-- Terminal mode mappings
bind('t', '<C-w>w', '<C-w>')
bind('t', '<C-w>o', '<C-\\><C-n><C-w>w')
bind('t', '<C-w>h', '<C-\\><C-n><C-w>h')
bind('t', '<C-w>k', '<C-\\><C-n><C-w>k')
bind('t', '<C-w>j', '<C-\\><C-n><C-w>j')
bind('t', '<C-w>l', '<C-\\><C-n><C-w>l')
bind('t', '<C-o>t', '<C-\\><C-n>gt')
bind('t', '<C-o>T', '<C-\\><C-n>gT')


-- ========================================================================== --
-- ==                           COMMAND MAPPINGS                           == --
-- ========================================================================== --

-- Moving lines and preserving indentation
bind('n', '<C-j>', "<cmd>move .+1<cr>==")
bind('n', '<C-k>', "<cmd>move .-2<cr>==")
bind('x', '<C-j>', "<esc><cmd>'<,'>move '>+1<cr>gv=gv")
bind('x', '<C-k>', "<esc><cmd>'<,'>move '<-2<cr>gv=gv")

-- Write file
bind('n', '<leader>w', '<cmd>write<cr>')

-- Safe quit
bind('n', '<leader>qq', '<cmd>quitall<cr>')

-- Force quit
bind('n', '<leader>Q', '<cmd>quitall!<cr>')

-- Close buffer
bind('n', '<leader>bq', '<cmd>bdelete<cr>')

-- Move to last active buffer
bind('n', '<leader>bl', '<cmd>buffer #<cr>')

-- Navigate between buffers
bind('n', '[b', '<cmd>bprevious<cr>')
bind('n', ']b', '<cmd>bnext<cr>')

-- Open new tabpage
bind('n', '<leader>tn', '<cmd>tabnew<cr>')

-- Navigate between tabpages
bind('n', '[t', '<cmd>tabprevious<cr>')
bind('n', ']t', '<cmd>tabnext<cr>')

-- Clear messages
bind('n', '<leader><space>', "<cmd>echo ''<cr>")

-- Switch to the directory of the open buffer
bind('n', '<leader>cd', '<cmd>lcd %:p:h<cr><cmd>pwd<cr>')

-- Put selected text in register '/'
bind('x', '<leader>y', '<Esc><cmd>GetSelection<cr>gv')
bind('x', '<leader>Y', '<Esc><cmd>GetSelection<cr><cmd>set hlsearch<cr>')

-- ========================================================================== --
-- ==                           TOGGLE ELEMENTS                            == --
-- ========================================================================== --

-- Search result highlight
bind('n', '<leader>uh', '<cmd>set invhlsearch<cr>')

-- Tabline
bind('n', '<leader>ut', '<cmd>ToggleOpt! showtabline o 1 0<cr>')

-- Line length ruler
bind('n', '<leader>ul', '<cmd>ToggleOpt colorcolumn wo 81 0<cr>')

-- Cursorline highlight
bind('n', '<leader>uc', '<cmd>set invcursorline<cr>')

-- Line numbers
bind('n', '<leader>un', '<cmd>set invnumber<cr>')

-- Relative line numbers
bind('n', '<leader>ur', '<cmd>set invrelativenumber<cr>')

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

-- Show line diagnostics
bind('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

-- Add word to search then replace
bind('n', 'sj', [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_ciw]])

-- Add selection to search then replace
bind('x', 'sj', [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>"_cgn]])

-- Begin a "searchable" macro
bind('x', 'qi', [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>gvqi]])

-- Apply macro in the next instance of the search
bind('n', '<F8>', 'gn@i')

-- Record macro on word
bind('n', 'sq', [[<cmd>let @/=expand('<cword>')<cr>viwo<Esc>qi]])

-- Apply @i macro
bind('n', 'sQ', '@i')

-- Repeat recently used macro
bind('n', 'Q', '@@')

-- Undo break points
local break_points = {'<Space>', '-', '_', ':', '.', '/'}
for _, char in ipairs(break_points) do
  bind('i', char, char .. '<C-g>u')
end


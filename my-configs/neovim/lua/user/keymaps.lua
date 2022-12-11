local fns = require('user.functions')

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

-- Select all text in current buffer
bind('n', '<Leader>a', ':keepjumps normal! ggVG<CR>')

-- Go to matching pair
bind({'n', 'x'}, '<Leader>e', '%', remap)

-- Go to first character in line
bind('', '<Leader>h', '^')

-- Go to last character in line
bind('', '<Leader>l', 'g_')

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
bind({'i', 'c'}, '<M-1>', '<')
bind({'i', 'c'}, '<M-2>', '>', remap)
bind('i', '<M-Space>', '<Enter><Up><Esc>o')

-- Whatever you delete, make it go away
bind({'n', 'x'}, 'c','"_c')
bind({'n', 'x'}, 'C','"_C')

bind({'n', 'x'}, 'x','"_x')
bind('x', 'X','"_c')

-- ========================================================================== --
-- ==                           COMMAND MAPPINGS                           == --
-- ========================================================================== --

-- Moving lines and preserving indentation
bind('n', '<C-j>', ":move .+1<CR>==")
bind('n', '<C-k>', ":move .-2<CR>==")
bind('v', '<C-j>', ":move '>+1<CR>gv=gv")
bind('v', '<C-k>', ":move '<-2<CR>gv=gv")

-- Write file
bind('n', '<Leader>w', ':write<CR>')

-- Safe quit
bind('n', '<Leader>qq', ':quitall<CR>')

-- Force quit
bind('n', '<Leader>Q', ':quitall!<CR>')

-- Close buffer
bind('n', '<Leader>bq', ':bdelete<CR>')

-- Move to last active buffer
bind('n', '<Leader>bl', ':buffer #<CR>')

-- Navigate between buffers
bind('n', '[b', ':bprevious<CR>')
bind('n', ']b', ':bnext<CR>')

-- Open new tabpage
bind('n', '<Leader>tn', ':tabnew<CR>')

-- Navigate between tabpages
bind('n', '[t', ':tabprevious<CR>')
bind('n', ']t', ':tabnext<CR>')

-- Clear messages
bind('n', '<Leader><space>', ":echo ''<CR>")

-- Switch to the directory of the open buffer
bind('n', '<Leader>cd', ':lcd %:p:h<CR>:pwd<CR>')

-- Put selected text in register '/'
bind('x', '<Leader>y', ':<C-u>GetSelection<CR>gv')
bind('x', '<Leader>Y', ':<C-u>GetSelection<CR>:set hlsearch<CR>')

-- ========================================================================== --
-- ==                           TOGGLE ELEMENTS                            == --
-- ========================================================================== --

-- Search result highlight
bind('n', '<Leader>uh', '<cmd>set invhlsearch<CR>')

-- Tabline
bind('n', '<Leader>ut', fns.toggle_opt('showtabline', 'o', 1, 0))

-- Line length ruler
bind('n', '<Leader>ul', fns.toggle_opt('colorcolumn', 'wo', '81', '0'))

-- Cursorline highlight
bind('n', '<Leader>uc', '<cmd>set invcursorline<CR>')

-- Line numbers
bind('n', '<Leader>un', '<cmd>set invnumber<CR>')

-- Relative line numbers
bind('n', '<Leader>ur', '<cmd>set invrelativenumber<CR>')

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

-- Add word to search then replace
bind('n', '<Leader>j', [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_ciw]])

-- Add selection to search then replace
bind('x', '<Leader>j', [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>"_cgn]])

-- Begin a "searchable" macro
bind('x', 'qi', [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>gvqi]])

-- Apply macro in the next instance of the search
bind('n', '<F8>', 'gn@i')

-- Load neogit
bind('n', '<leader>g', function()
  if vim.fn.executable('git') == 1 then
    vim.cmd('PackAdd neogit')
    vim.cmd('Neogit')
  else
    vim.notify('git is not available', vim.log.levels.WARN)
  end
end, {desc = 'Open Neogit'})

-- Undo break points
local break_points = {'<Space>', '-', '_', ':', '.', '/'}
for _, char in ipairs(break_points) do
  bind('i', char, char .. '<C-g>u')
end


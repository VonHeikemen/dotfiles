-- astronauta might not be installed yet
local ok, k = pcall(require, 'astronauta.keymap')

if not ok then
  return
end

local fns = require('conf.functions')
local autocmd = require('bridge').augroup('mapping_cmds')

-- Leader
vim.g.mapleader = ' '

-- ========================================================================== --
-- ==                             KEY MAPPINGS                             == --
-- ========================================================================== --

-- Enter command mode
k.nnoremap {'<CR>', ':'}

-- Escape to normal mode
k.noremap  {'<C-L>', '<Esc>'}
k.inoremap {'<C-L>', '<Esc>'}
k.tnoremap {'<C-L>', '<C-\\><C-n>'}

-- Select all text in current buffer
k.nnoremap {'<Leader>a', 'ggVG'}

-- Go to matching pair
k.nmap {'<Leader>e', '%'}
k.vmap {'<Leader>e', '%'}

-- Go to first character in line
k.noremap {'<Leader>h', '^'}

-- Go to last character in line
k.noremap {'<Leader>l', 'g_'}

-- Scroll half page and center
k.noremap {'<C-u>', '<C-u>M'}
k.noremap {'<C-d>', '<C-d>M'}

-- Search will center on the line it's found in
k.nnoremap {'n', 'nzzzv'}
k.nnoremap {'N', 'Nzzzv'}
k.nnoremap {'#', '#zz'}
k.nnoremap {'*', '*zz'}

-- Better ctrl+h
k.snoremap {'<C-h>', '<Space><BS>'}
k.imap {'<C-h>', '<BS>'}

-- Yank, delete and paste will use the x register
k.nnoremap {'y', '"xy'}
k.vnoremap {'y', '"xy'}
k.nnoremap {'Y', '"xy$'}
k.nnoremap {'d', '"xd'}
k.vnoremap {'d', '"xd'}
k.nnoremap {'D', '"xD'}
k.nnoremap {'p', '"xp'}
k.vnoremap {'p', '"xp'}
k.nnoremap {'P', '"xP'}

-- ========================================================================== --
-- ==                           COMMAND MAPPINGS                           == --
-- ========================================================================== --

-- Moving lines and preserving indentation
k.nnoremap {'<C-j>', ":move .+1<CR>=="}
k.nnoremap {'<C-k>', ":move .-2<CR>=="}
k.vnoremap {'<C-j>', ":move '>+1<CR>gv=gv"}
k.vnoremap {'<C-k>', ":move '<-2<CR>gv=gv"}

-- Write file
k.nnoremap {'<Leader>w', ':write<CR>'}

-- Safe quit
k.nnoremap {'<Leader>qq', ':quitall<CR>'}

-- Force quit
k.nnoremap {'<Leader>Q', ':quitall!<CR>'}

-- Close buffer
k.nnoremap {'<Leader>bq', ':bdelete<CR>'}

-- Move to last active buffer
k.nnoremap {'<Leader>bl', ':buffer #<CR>'}

-- Navigate between buffers
k.nnoremap {'[b', ':bprevious<CR>'}
k.nnoremap {']b', ':bnext<CR>'}

-- Open new tabpage
k.nnoremap {'<Leader>tn', ':tabnew<CR>'}

-- Navigate between tabpages
k.nnoremap {'[t', ':tabprevious<CR>'}
k.nnoremap {']t', ':tabnext<CR>'}

-- Clear messages
k.nnoremap {'<Leader><space>', ":echo ''<CR>"}

-- Switch to the directory of the open buffer
k.nnoremap {'<Leader>cd', ':lcd %:p:h<CR>:pwd<CR>'}

-- ========================================================================== --
-- ==                           TOGGLE ELEMENTS                            == --
-- ========================================================================== --

-- Search result highlight
k.nnoremap {'<Leader>uh', fns.toggle_opt('hlsearch')}

-- Tabline
k.nnoremap {'<Leader>ut', fns.toggle_opt('showtabline', 'o', 1, 0)}

-- Line length ruler
k.nnoremap {'<Leader>ul', fns.toggle_opt('colorcolumn', 'wo', '81', '0')}

-- Cursorline highlight
k.nnoremap {'<Leader>uc', fns.toggle_opt('cursorline')}

-- Line numbers
k.nnoremap {'<Leader>un', fns.toggle_opt('number')}

-- Relative line numbers
k.nnoremap {'<Leader>ur', fns.toggle_opt('relativenumber')}

-- ========================================================================== --
-- ==                           SEARCH COMMANDS                            == --
-- ========================================================================== --

-- Show key bindings list
k.nnoremap {'<Leader>?', ':Telescope keymaps<CR>'}

-- Search pattern
k.nnoremap {'<Leader>F', ':TGrep '}
k.xnoremap {'<Leader>F', ':<C-u>GetSelection<CR>:TGrep <C-R>/'}

-- Find files by name
k.nnoremap {'<Leader>ff', ':Telescope find_files<CR>'}

-- Find files by name
k.nnoremap {'<Leader>fe', ':Telescope file_browser<CR>'}
k.nnoremap {'<Leader>fc', function()
  require('telescope.builtin').file_browser({cwd = vim.fn.expand('%:p:h')})
end}

-- Search symbols in buffer
k.nnoremap {'<Leader>fs', ':Telescope treesitter<CR>'}

-- Search in files history
k.nnoremap {'<Leader>fh', ':Telescope oldfiles<CR>'}

-- Search in active buffers list
k.nnoremap {'<Leader>bb', ':Telescope buffers<CR>'}
k.nnoremap {'<Leader>B', ':Telescope buffers only_cwd=true<CR>'}

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

-- Begin search & replace using the selected text
k.nnoremap {'<Leader>r', ':%s///gc<Left><Left><Left><Left>'}
k.xnoremap {'<Leader>r', ':s///gc<Left><Left><Left><Left>'}
k.xnoremap {'<Leader>R', ':<C-u>GetSelection<CR>:%s/\\V<C-R>=@/<CR>//gc<Left><Left><Left>'}

-- Put selected text in register '/'
k.vnoremap {'<Leader>y', ':<C-u>GetSelection<CR>gv'}
k.vnoremap {'<Leader>Y', ':<C-u>GetSelection<CR>:set hlsearch<CR>'}

-- Close buffer while preserving the layout
k.nnoremap {'<Leader>bc', ':Bdelete<CR>'}

-- Toggle zen-mode
k.nnoremap {'<Leader>uz', ':ZenMode<CR>'}

-- Manage the quickfix list
k.nmap {'[q', '<Plug>(qf_qf_previous)zz'}
k.nmap {']q', '<Plug>(qf_qf_next)zz'}
k.nmap {'<Leader>cc', '<Plug>(qf_qf_toggle)'}

autocmd({'filetype', 'qf'}, function()
  -- Go to location under the cursor
  k.nnoremap {buffer = true, 'gl', '<CR>'}

  -- Go to next location and stay in the quickfix window
  k.nmap {buffer = true, 'K', '<Plug>(qf_qf_previous)zz<C-w>w'}

  -- Go to previous location and stay in the quickfix window
  k.nmap {buffer = true, 'J', '<Plug>(qf_qf_next)zz<C-w>w'}

  -- Toggle nvim-bqf
  k.nmap {buffer = true, 'p', ':BqfEnable<CR>'}
  k.nmap {buffer = true, 'P', ':BqfDisable<CR>'}
end)

-- Open file manager
k.nnoremap {silent = true, '<leader>dd', ":lua require('lir.float').toggle()<CR>"}
k.nnoremap {silent = true, '<leader>da', ":lua require('lir.float').toggle(vim.fn.getcwd())<CR>"}
k.nnoremap {silent = true, '-', ":exe 'edit' expand('%:p:h')<CR>"}
k.nnoremap {silent = true, '_', ":exe 'edit' getcwd()<CR>"}

-- Undo break points
local break_points = {'<Space>', '-', '_', ':', '.', '/'}
for _, char in ipairs(break_points) do
  k.inoremap {char, char .. '<C-g>u'}
end


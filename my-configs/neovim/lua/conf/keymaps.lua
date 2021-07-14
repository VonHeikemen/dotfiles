-- astronauta might not be installed yet
local status, k = pcall(require, 'astronauta.keymap')

if not status then
  return
end

local fns = require 'conf.functions'
local t = fns.t

local lua_expr = require 'bridge'.lua_expr
local autocmd = require 'bridge'.augroup 'mapping_cmds'

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
k.nnoremap {'<Leader>a', 'ggvGg_'}

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
k.nnoremap {'<Leader>?', ':Maps<CR>'}

-- Search pattern
k.nnoremap {'<Leader>F', ':Rg<Space>'}
k.xnoremap {'<Leader>F', ':<C-u>GetSelection<CR>:Rg<Space><C-R>/'}

-- Find files by name
k.nnoremap {'<Leader>f', ':FZF<Space>'}
k.nnoremap {'<Leader>ff', ':FZF<CR>'}

-- Search symbols in buffer
k.nnoremap {'<Leader>fs', ':BTags<CR>'}

-- Search symbols in workspace
k.nnoremap {'<Leader>fS', ':Tags<CR>'}

-- Go to definition (using tags)
k.nnoremap {'gd', ':FZFTags<CR>'}

-- Search in files history
k.nnoremap {'<Leader>fh', ':History<CR>'}

-- Search in active buffers list
k.nnoremap {'<Leader>bb', ':Buffers<CR>'}

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

-- Insert mode completions
k.imap {expr = true, '<Tab>', lua_expr(fns.tab_complete)}
k.imap {expr = true, '<S-Tab>', lua_expr(fns.s_tab_complete)}
k.inoremap {expr = true, '<C-Space>', lua_expr(fns.toggle_completion)}
k.inoremap {expr = true, '<C-k>', lua_expr(fns.completion_up(t'<C-k>'))}
k.inoremap {expr = true, '<C-j>', lua_expr(fns.completion_down(t'<C-j>'))}
k.inoremap {expr = true, '<M-k>', "compe#scroll({ 'delta': -4 })"}
k.inoremap {expr = true, '<M-j>', "compe#scroll({ 'delta': +4 })"}

-- use built-in `f` and `F` while recording a macro
k.nmap {expr = true, 'f', lua_expr(fns.lightspeed('f'))}
k.nmap {expr = true, 'F', lua_expr(fns.lightspeed('F'))}

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
end)

-- Open file manager
k.nnoremap {'<leader>dd', ':Vaffle %:p:h<CR>'}
k.nnoremap {'<leader>da', ':Vaffle<CR>'}

autocmd({'filetype', 'vaffle'}, function ()
  k.nmap {buffer = true, '<CR>', ':'}

  k.nmap {buffer = true, 'e', '<Plug>(vaffle-open-selected)'}
  k.nmap {buffer = true, 'u', '<Plug>(vaffle-open-selected-split)'}
  k.nmap {buffer = true, 'v', '<Plug>(vaffle-open-selected-vsplit)'}

  k.nmap {buffer = true, '<Leader>dd', 'quit'}
  k.nmap {buffer = true, '<Leader>da', 'quit'}
end)


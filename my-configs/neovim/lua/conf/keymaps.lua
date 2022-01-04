local fns = require('conf.functions')

local autocmd = require('bridge').augroup('mapping_cmds')
local luafn = require('bridge').lua_map
local bind = vim.api.nvim_set_keymap

-- Bind options
local remap = function(m, lhs, rhs) bind(m, lhs, rhs, {noremap = false}) end
local noremap = function(m, lhs, rhs) bind(m, lhs, rhs, {noremap = true}) end
local bufmap = function(...) vim.api.nvim_buf_set_keymap(0, ...) end

-- Leader
vim.g.mapleader = ' '

-- ========================================================================== --
-- ==                             KEY MAPPINGS                             == --
-- ========================================================================== --

-- Enter commands
noremap('n', '<CR>', ':FineCmdline<CR>')

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

-- Delete in select mode
noremap('s', '<BS>', '<C-g>"_c')
remap('s', '<C-h>', '<BS>')

-- Because of reasons
remap('i', '<C-h>', '<BS>')

-- Whatever you delete, make it go away
noremap('n', 'c','"_c')
noremap('n', 'C','"_C')
noremap('x', 'c','"_c')
noremap('x', 'C','"_C')

noremap('n', 'x','"_x')
noremap('x', 'x','"_x')

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
noremap('n', '<Leader>uh', '<cmd>set invhlsearch<CR>')

-- Tabline
noremap('n', '<Leader>ut', luafn(fns.toggle_opt('showtabline', 'o', 1, 0)))

-- Line length ruler
noremap('n', '<Leader>ul', luafn(fns.toggle_opt('colorcolumn', 'wo', '81', '0')))

-- Cursorline highlight
noremap('n', '<Leader>uc', '<cmd>set invcursorline<CR>')

-- Line numbers
noremap('n', '<Leader>un', '<cmd>set invnumber<CR>')

-- Relative line numbers
noremap('n', '<Leader>ur', '<cmd>set invrelativenumber<CR>')

-- ========================================================================== --
-- ==                           SEARCH COMMANDS                            == --
-- ========================================================================== --

-- Show key bindings list
noremap('n', '<Leader>?', ':Telescope keymaps<CR>')

-- Search pattern
noremap('n', '<leader>F', ':FineCmdline TGrep <CR>')
noremap('x', '<Leader>F', ':<C-u>GetSelection<CR>:TGrep <C-r>/<CR>')
noremap('n', '<Leader>fw', ":TGrep <C-r>=expand('<cword>')<CR><CR>")
noremap('n', '<leader>fg', ':Telescope live_grep<CR>')

-- Find files by name
noremap('n', '<Leader>ff', ':Telescope find_files<CR>')

-- Search symbols in buffer
noremap('n', '<Leader>fs', ':Telescope treesitter<CR>')

-- Search in files history
noremap('n', '<Leader>fh', ':Telescope oldfiles<CR>')

-- Search in active buffers list
noremap('n', '<Leader>bb', ':Telescope buffers<CR>')
noremap('n', '<Leader>B', ':Telescope buffers only_cwd=true<CR>')

-- Put selected text in register '/'
noremap('v', '<Leader>y', ':<C-u>GetSelection<CR>gv')
noremap('v', '<Leader>Y', ':<C-u>GetSelection<CR>:set hlsearch<CR>')

-- Nice buffer local search
noremap('n', '<leader>s', ":lua require('searchbox').incsearch()<CR>")
noremap('x', '<leader>s', "<Esc>:lua require('searchbox').incsearch({visual_mode = true})<CR>")
noremap('n', '<leader>S', ":lua require('searchbox').match_all({title = ' Match '})<CR>")
noremap('x', '<leader>S', "<Esc>:lua require('searchbox').match_all({title = ' Match ', visual_mode = true})<CR>")

-- Buffer local search and replace
noremap('n', '<leader>r', ":lua require('searchbox').replace({confirm = 'menu'})<CR>")
noremap('x', '<leader>r', "<Esc>:lua require('searchbox').replace({confirm = 'menu', visual_mode = true})<CR>")
noremap('n', '<leader>R', ":lua require('searchbox').replace({default_value = vim.fn.expand('<cword>'), confirm = 'menu'})<CR>")
noremap('x', '<leader>R', ":<C-u>GetSelection<CR>:lua require('searchbox').replace({confirm = 'menu'})<CR><C-r>/")

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

-- Close buffer while preserving the layout
noremap('n', '<Leader>bc', ':Bdelete<CR>')

-- Toggle zen-mode
noremap('n', '<Leader>uz', '<cmd>ZenMode<CR>')

-- Override some `cv` bindings from `vim-system-copy`.
remap('n', 'cvv', 'ax<Esc><plug>SystemPastel')
remap('n', 'cvk', 'Ox<Esc><Plug>SystemPastel')
remap('n', 'cvj', 'ox<Esc><Plug>SystemPastel')

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
noremap('n', '<leader>dd', "<cmd>lua require('lir.float').toggle()<CR>")
noremap('n', '<leader>da', "<cmd>lua require('lir.float').toggle(vim.fn.getcwd())<CR>")
noremap('n', '-', "<cmd>exe 'edit' getcwd()<CR>")
noremap('n', '_', "<cmd>exe 'edit' expand('%:p:h')<CR>")

-- Undo break points
local break_points = {'<Space>', '-', '_', ':', '.', '/'}
for _, char in ipairs(break_points) do
  noremap('i', char, char .. '<C-g>u')
end


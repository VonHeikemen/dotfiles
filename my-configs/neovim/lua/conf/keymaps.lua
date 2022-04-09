local fns = require('conf.functions')

local autocmd = require('bridge').augroup('mapping_cmds')
local bind = vim.keymap.set

-- Bind options
local remap = function(m, lhs, rhs) bind(m, lhs, rhs, {remap = true}) end
local noremap = function(m, lhs, rhs) bind(m, lhs, rhs, {remap = false}) end

-- Leader
vim.g.mapleader = ' '

-- ========================================================================== --
-- ==                             KEY MAPPINGS                             == --
-- ========================================================================== --

-- Enter commands
noremap('n', '<CR>', ':FineCmdline<CR>')

-- Select all text in current buffer
noremap('n', '<Leader>a', ':keepjumps normal! ggVG<CR>')

-- Go to matching pair
remap({'n', 'x'}, '<Leader>e', '%')

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
noremap('x', 'X','"_c')

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
noremap('n', '<Leader>ut', fns.toggle_opt('showtabline', 'o', 1, 0))

-- Line length ruler
noremap('n', '<Leader>ul', fns.toggle_opt('colorcolumn', 'wo', '81', '0'))

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
noremap('n', '<leader>s', ':SearchBoxIncSearch<CR>')
noremap('x', '<leader>s', ':SearchBoxIncSearch visual_mode=true<CR>')
noremap('n', '<leader>S', ":SearchBoxMatchAll title=' Match '<CR>")
noremap('x', '<leader>S', ":SearchBoxMatchAll title=' Match ' visual_mode=true<CR>")
noremap('n', '<leader>;', '<cmd>SearchBoxClear<CR>')

-- Begin search & replace
noremap('n', '<leader>r', ":SearchBoxReplace confirm=menu<CR>")
noremap('x', '<leader>r', ":SearchBoxReplace confirm=menu visual_mode=true<CR>")
noremap('n', '<leader>R', ":SearchBoxReplace confirm=menu -- <C-r>=expand('<cword>')<CR><CR>")
noremap('x', '<leader>R', ":<C-u>GetSelection<CR>:SearchBoxReplace confirm=menu<CR><C-r>/")

-- ========================================================================== --
-- ==                                 LSP                                  == --
-- ========================================================================== --

autocmd({'User', 'LSPKeybindings'}, function()
  local telescope = require('telescope.builtin')
  local lsp = vim.lsp.buf

  local opts = {silent = true, buffer = true}

  bind('n', '<leader>fi', '<cmd>LspInfo<cr>', opts)

  bind('n', 'K', lsp.hover, opts)
  bind('n', 'gd', lsp.definition, opts)
  bind('n', 'gD', lsp.declaration, opts)
  bind('n', 'gi', lsp.implementation, opts)
  bind('n', 'go', lsp.type_definition, opts)
  bind('n', 'gr', lsp.references, opts)
  bind('n', 'gs', lsp.signature_help, opts)
  bind('n', '<F2>', lsp.rename, opts)
  bind('n', '<F4>', lsp.code_action, opts)
  bind('x', '<F4>', lsp.range_code_action, opts)

  bind('i', '<M-i>', lsp.signature_help, opts)

  bind('n', 'gl', vim.diagnostic.open_float, opts)
  bind('n', '[d', vim.diagnostic.goto_prev, opts)
  bind('n', ']d', vim.diagnostic.goto_next, opts)

  bind('n', '<leader>fd', telescope.lsp_document_symbols, opts)
  bind('n', '<leader>fq', telescope.lsp_workspace_symbols, opts)
  bind('n', '<leader>fa', telescope.lsp_code_actions, opts)
end)

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

-- Change the whole word
noremap('n', 'cw', '"_ciw')

-- Change word but repeatable
noremap('n', '<leader>cw', "<cmd>let @/='\\<'.expand('<cword>').'\\>'<cr>\"_ciw")

-- Use lightspeed's omni mode
remap('', 's', '<Plug>Lightspeed_omni_s')

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
  local opts = {remap = true, buffer = true}

  -- Go to location under the cursor
  bind('n', '<CR>', '<CR>zz<C-w>w', {buffer = true})

  -- Go to next location and stay in the quickfix window
  bind('n', '<Up>', '<Plug>(qf_qf_previous)zz<C-w>w', opts)

  -- Go to previous location and stay in the quickfix window
  bind('n', '<Down>', '<Plug>(qf_qf_next)zz<C-w>w', opts)

  bind('n', '<leader>r', ':%s///g<Left><Left>', opts)
end)

-- Open file manager
noremap('n', '<leader>dd', fns.file_explorer)
noremap('n', '<leader>da', function() fns.file_explorer(vim.fn.getcwd()) end)

-- Undo break points
local break_points = {'<Space>', '-', '_', ':', '.', '/'}
for _, char in ipairs(break_points) do
  noremap('i', char, char .. '<C-g>u')
end


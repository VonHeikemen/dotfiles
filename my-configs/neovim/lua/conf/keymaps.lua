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
  local fmt = function(cmd) return function(str) return cmd:format(str) end end

  local lsp = fmt('<cmd>lua vim.lsp.%s<cr>')
  local diagnostic = fmt('<cmd>lua vim.diagnostic.%s<cr>')
  local telescope = fmt('<cmd>lua require("telescope.builtin").%s<cr>')

  local opts = {noremap = true, silent = true}

  bufmap('n', '<leader>fi', '<cmd>LspInfo<cr>', opts)

  bufmap('n', 'K', lsp 'buf.hover()', opts)
  bufmap('n', 'gd', lsp 'buf.definition()', opts)
  bufmap('n', 'gD', lsp 'buf.declaration()', opts)
  bufmap('n', 'gi', lsp 'buf.implementation()', opts)
  bufmap('n', 'go', lsp 'buf.type_definition()', opts)
  bufmap('n', 'gr', lsp 'buf.references()', opts)
  bufmap('n', 'gs', lsp 'buf.signature_help()', opts)
  bufmap('n', '<F2>', lsp 'buf.rename()', opts)
  bufmap('n', '<F4>', lsp 'buf.code_action()', opts)

  bufmap('i', '<M-i>', lsp 'buf.signature_help()', opts)

  bufmap('n', 'gl', diagnostic 'open_float()', opts)
  bufmap('n', '[d', diagnostic 'goto_prev()', opts)
  bufmap('n', ']d', diagnostic 'goto_next()', opts)

  bufmap('n', '<leader>fd', telescope 'lsp_document_symbols()', opts)
  bufmap('n', '<leader>fq', telescope 'lsp_workspace_symbols()', opts)
  bufmap('n', '<leader>fa', telescope 'lsp_code_actions()', opts)
end)

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

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
  local opts = {noremap = false}
  -- Go to location under the cursor
  bufmap('n', 'gl', '<CR>', {noremap = true})

  -- Go to next location and stay in the quickfix window
  bufmap('n', 'K', '<Plug>(qf_qf_previous)zz<C-w>w', opts)

  -- Go to previous location and stay in the quickfix window
  bufmap('n', 'J', '<Plug>(qf_qf_next)zz<C-w>w', opts)

  bufmap('n', '<leader>r', ':%s///g<Left><Left>', opts)
end)

-- Open file manager
noremap('n', '<leader>dd', luafn(fns.file_explorer))
noremap('n', '<leader>da', luafn(function() fns.file_explorer(vim.fn.getcwd()) end))

-- Undo break points
local break_points = {'<Space>', '-', '_', ':', '.', '/'}
for _, char in ipairs(break_points) do
  noremap('i', char, char .. '<C-g>u')
end


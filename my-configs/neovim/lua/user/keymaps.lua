local fns = require('user.functions')

local augroup = vim.api.nvim_create_augroup('mapping_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd

-- Bind options
local bind = vim.keymap.set
local remap = {remap = true}

-- Leader
vim.g.mapleader = ' '

-- Disable vim-surround default mappings
vim.g.surround_no_mappings = 1

-- ========================================================================== --
-- ==                             KEY MAPPINGS                             == --
-- ========================================================================== --

-- Enter commands
bind('n', '<CR>', ':FineCmdline<CR>')

-- Select all text in current buffer
bind('n', '<Leader>a', ':keepjumps normal! ggVG<CR>')

-- Go to matching pair
bind({'n', 'x'}, '<Leader>e', '%', remap)

-- Go to first character in line
bind('', '<Leader>h', '^')

-- Go to last character in line
bind('', '<Leader>l', 'g_')

-- Scroll half page and center
bind('', '<C-u>', '<C-u>M')
bind('', '<C-d>', '<C-d>M')

-- Search will center on the line it's found in
bind('n', 'n', 'nzzzv')
bind('n', 'N', 'Nzzzv')
bind('n', '#', '#zz')
bind('n', '*', '*zz')

-- Delete in select mode
bind('s', '<BS>', '<C-g>"_c')
bind('s', '<C-h>', '<BS>', remap)

-- Because of reasons
bind('i', '<C-h>', '<BS>', remap)

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
-- ==                           SEARCH COMMANDS                            == --
-- ========================================================================== --

-- Show key bindings list
bind('n', '<Leader>?', ':Telescope keymaps<CR>')

-- Search pattern
bind('n', '<leader>F', ':FineCmdline Find <CR>')
bind('x', '<Leader>F', ':<C-u>GetSelection<CR>:Find <C-r>/<CR>')
bind('n', '<Leader>fw', ":Find <C-r>=expand('<cword>')<CR><CR>")
bind('n', '<leader>fg', ':Telescope live_grep<CR>')

-- Find files by name
bind('n', '<Leader>ff', ':Telescope find_files<CR>')

-- Search symbols in buffer
bind('n', '<Leader>fs', ':Telescope treesitter<CR>')

-- Search in files history
bind('n', '<Leader>fh', ':Telescope oldfiles<CR>')

-- Search in active buffers list
bind('n', '<Leader>bb', ':Telescope buffers<CR>')
bind('n', '<Leader>B', ':Telescope buffers only_cwd=true<CR>')

-- Put selected text in register '/'
bind('v', '<Leader>y', ':<C-u>GetSelection<CR>gv')
bind('v', '<Leader>Y', ':<C-u>GetSelection<CR>:set hlsearch<CR>')

-- Nice buffer local search
bind('n', 's', ':SearchBoxIncSearch<CR>')
bind('x', 's', ':SearchBoxIncSearch visual_mode=true<CR>')
bind('n', 'S', ":SearchBoxMatchAll title=' Match '<CR>")
bind('x', 'S', ":SearchBoxMatchAll title=' Match ' visual_mode=true<CR>")
bind('n', '<leader>;', '<cmd>SearchBoxClear<CR>')

-- Begin search & replace
bind('n', 'r', ":SearchBoxReplace confirm=menu<CR>")
bind('x', 'r', ":SearchBoxReplace confirm=menu visual_mode=true<CR>")
bind('n', 'R', ":SearchBoxReplace confirm=menu -- <C-r>=expand('<cword>')<CR><CR>")
bind('x', 'R', ":<C-u>GetSelection<CR>:SearchBoxReplace confirm=menu<CR><C-r>/")

-- ========================================================================== --
-- ==                                 LSP                                  == --
-- ========================================================================== --

autocmd('User', {
  pattern = 'LSPKeybindings',
  group = augroup,
  callback = function()
    local telescope = require('telescope.builtin')
    local lsp = vim.lsp.buf

    local opts = {silent = true, buffer = true}

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
  end
})

-- ========================================================================== --
-- ==                            MISCELLANEOUS                             == --
-- ========================================================================== --

-- Change word under cursor
bind('n', 'cj', '"_ciw')

-- Add word to search then replace
bind('n', '<Leader>j', [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_ciw]])

-- Add selection to search then replace
bind('x', '<Leader>j', [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>"_cgn]])

-- Begin a "searchable" macro
bind('x', 'qi', [[y<cmd>let @/=substitute(escape(@", '/'), '\n', '\\n', 'g')<cr>gvqi]])

-- Apply macro in the next instance of the search
bind('n', '<F8>', 'gn@i')

-- Close buffer while preserving the layout
bind('n', '<Leader>bc', ':Bdelete<CR>')

-- Toggle zen-mode
bind('n', '<Leader>uz', '<cmd>Goyo<CR>')

-- Toggle indentline guides
bind('n', '<leader>ui', '<cmd>IndentBlanklineToggle<cr>')

-- Override some `cv` bindings from `vim-system-copy`.
bind('n', 'cvv', 'ax<Esc><plug>SystemPastel', remap)
bind('n', 'cvk', 'Ox<Esc><Plug>SystemPastel', remap)
bind('n', 'cvj', 'ox<Esc><Plug>SystemPastel', remap)

-- Toggle harpoon mark
bind('n', '<leader>m', '<cmd>lua require("harpoon.mark").add_file()<cr>')

-- Search marks
bind('n', '<F3>', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>')

-- Navigate marks
bind('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>')
bind('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>')
bind('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>')
bind('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>')

-- Manage the quickfix list
bind('n', '[q', '<Plug>(qf_qf_previous)zz')
bind('n', ']q', '<Plug>(qf_qf_next)zz')
bind('n', '<Leader>cc', '<Plug>(qf_qf_toggle)')

autocmd('filetype', {
  pattern = 'qf',
  group = augroup,
  callback = function()
    local opts = {remap = true, buffer = true}

    -- Go to location under the cursor
    bind('n', '<CR>', '<CR>zz<C-w>w', {buffer = true})

    -- Go to next location and stay in the quickfix window
    bind('n', '<Up>', '<Plug>(qf_qf_previous)zz<C-w>w', opts)

    -- Go to previous location and stay in the quickfix window
    bind('n', '<Down>', '<Plug>(qf_qf_next)zz<C-w>w', opts)
  end
})

-- Open file manager
bind('n', '<leader>dd', fns.file_explorer)
bind('n', '<leader>da', function() fns.file_explorer(vim.fn.getcwd()) end)

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


local bind = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('qf_cmds', {clear = true})

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


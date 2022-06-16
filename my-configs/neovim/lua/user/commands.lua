local env = require('user.env')
local fns = require('user.functions')

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', {clear = true})

command('GetSelection', fns.get_selection, {desc = 'Get selected text'})
command('TrailspaceTrim', fns.trailspace_trim, {desc = 'Delete extra whitespace'})
command('EditMacro', fns.edit_macro, {desc = 'Create/Edit macro in an input'})
command('LoadProject', fns.load_project, {desc = 'Parse project config'})

autocmd('TextYankPost', {
  desc = 'highlight text after is copied',
  group = augroup,
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 200})
  end
})

autocmd('CmdWinEnter', {
  group = augroup,
  command = 'quit'
})

autocmd('FileType', {
  group = augroup,
  pattern = {'qf', 'help', 'man', 'lspinfo'},
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

if env.preserve_beam_cursor then
  autocmd('VimLeave', {
    group = augroup,
    command = 'set guicursor=a:ver25'
  })
end


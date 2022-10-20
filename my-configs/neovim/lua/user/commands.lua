local env = require('user.env')
local fns = require('user.functions')

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', {clear = true})

command('GetSelection', fns.get_selection, {desc = 'Get selected text'})
command('TrailspaceTrim', fns.trailspace_trim, {desc = 'Delete extra whitespace'})
command('EditMacro', fns.edit_macro, {desc = 'Create/Edit macro in an input'})
command('LoadProject', fns.load_project, {desc = 'Parse project config'})
command('AutoIndent', fns.set_autoindent, {desc = 'Guess indentantion in all files'})
command('SyntaxQuery', fns.syntax_query, {desc = 'Show highlight group'})

command(
  'Lsp',
  function(input)
    local lsp = require('lsp')
    if input.args == '' then
      return
    end

    lsp.start(input.args, {})
  end,
  {desc = 'Initialize a language server', nargs = '?'}
)

autocmd('TextYankPost', {
  desc = 'highlight text after is copied',
  group = augroup,
  callback = function()
    vim.highlight.on_yank({higroup = 'Visual', timeout = 80})
  end
})

autocmd('CmdWinEnter', {group = augroup, command = 'quit'})

autocmd('FileType', {
  group = augroup,
  pattern = {'qf', 'help', 'man', 'lspinfo', 'harpoon', 'null-ls-info'},
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

if env.preserve_beam_cursor then
  autocmd('VimLeave', {group = augroup, command = 'set guicursor=a:ver25'})
end


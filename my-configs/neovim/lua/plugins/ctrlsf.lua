local command = vim.api.nvim_create_user_command
local bind = vim.keymap.set

command('Find', function(input)
  vim.call('ctrlsf#Search', input.args)
end, {nargs = 1, desc = 'Search pattern using ripgrep'})

bind('n', '<leader>F', ':FineCmdline Find <CR>')
bind('x', '<Leader>F', ':<C-u>GetSelection<CR>:Find <C-r>/<CR>')
bind('n', '<Leader>fw', ":Find <C-r>=expand('<cword>')<CR><CR>")

vim.g.ctrlsf_default_root = 'cwd'
vim.g.ctrlsf_auto_focus = {at = 'start'}
vim.g.ctrlsf_winsize = '100%'
vim.g.ctrlsf_preview_position = 'inside'

vim.g.ctrlsf_mapping = {
  open = {'<CR>', 'e'},
  openb = 'E',
  split = 'ss',
  vsplit = 'sv',
  tab = 't',
  tabb = 'T',

  popen = 'p',
  pquit = 'q',
  popenf = {key = 'P', suffix = '<C-w>q'},

  quit = 'q',
  next = '<M-j>',
  prev = '<M-k>',
  nfile = 'H',
  pfile = 'L',

  chgmode = 'M',
  stop = '<C-c>'
}


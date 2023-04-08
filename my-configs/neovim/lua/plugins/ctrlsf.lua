-- Project Search
local Plugin = {'dyng/ctrlsf.vim'}

Plugin.cmd = 'Find'

function Plugin.init()
  local bind = vim.keymap.set

  bind('n', '<leader>F', '<cmd>FineCmdline Find <cr>')
  bind('x', '<leader>F', "<Esc><cmd>GetSelection<cr><cmd>exe 'Find' getreg('/')<cr>")
  bind('n', '<leader>fw', "<Esc><cmd>exe 'Find' expand('<cword>')<cr>")

  vim.g.ctrlsf_default_root = 'cwd'
  vim.g.ctrlsf_auto_focus = {at = 'start'}
  vim.g.ctrlsf_winsize = '100%'
  vim.g.ctrlsf_preview_position = 'inside'

  vim.g.ctrlsf_mapping = {
    open = {'<cr>'},
    openb = 'gf',
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
end

function Plugin.config()
  local command = vim.api.nvim_create_user_command
  command('Find', function(input)
    vim.call('ctrlsf#Search', input.args)
  end, {nargs = 1, desc = 'Search pattern using ripgrep'})
end

return Plugin


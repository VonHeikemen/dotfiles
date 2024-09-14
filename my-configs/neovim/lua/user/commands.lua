local env = require('user.env')

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', {clear = true})

command(
  'GetSelection',
  function()
    local f = vim.fn
    local temp = f.getreg('s')
    vim.cmd('normal! gv"sy')

    f.setreg('/', f.escape(f.getreg('s'), '/'):gsub('\n', '\\n'))

    f.setreg('s', temp)
  end,
  {desc = 'Get selected text'}
)

command(
  'TrailspaceTrim',
  function()
    -- Save cursor position to later restore
    local curpos = vim.api.nvim_win_get_cursor(0)

    -- Search and replace trailing whitespace
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, curpos)
  end,
  {desc = 'Delete extra whitespace'}
)

command(
  'AutoIndent',
  function()
    require('guess-indent').setup({auto_cmd = true, verbose = 1})

    vim.defer_fn(function()
      local bufnr = vim.fn.bufnr()
      vim.cmd('bufdo GuessIndent silent')
      vim.cmd({cmd = 'buffer', args = {bufnr}})
    end, 3)
  end,
  {desc = 'Guess indentantion in all files'}
)

command(
  'SyntaxQuery',
  function()
    local f = vim.fn
    local stack = f.synstack(f.line('.'), f.col('.'))

    if stack[1] == nil then
      print('No id found')
      return
    end

    for _, id in pairs(stack) do
      print(f.synIDattr(id, 'name'))
    end
  end,
  {desc = 'Show highlight group'}
)

command(
  'ProjectSet',
  function(input)
    local index = input.args:find(' ')
    local name = input.args
    local arg = nil

    if index then
      name = input.args:sub(1, index - 1)
      arg = vim.json.decode(input.args:sub(index + 1))
    end

    local settings = require('user.project-config')[name]

    if settings then
      settings(arg)
    end
  end,
  {desc = 'Use project settings', nargs = 1}
)

command(
  'ResumeWork',
  function(input)
    local project = require('project')
    local name = project.get_current()

    if name then
      project.load({name = name})
      return
    end

    local session = require('session')
    name = session.read_name(vim.fn.getcwd())

    if name then
      session.load_current(name)
      return
    end

    if input.bang then
      vim.cmd('cquit 2')
      return
    end

    local msg = 'There is no session or project available in the current folder'
    vim.notify(msg, vim.log.levels.WARN)
  end,
  {bang = true, desc = 'Load project or session in current folder'}
)

command(
  'ToggleOpt',
  function(input)
    local prop = input.fargs[1]
    local scope = input.fargs[2]
    local on =  input.fargs[3]
    local off = input.fargs[4]

    if input.bang then
      on = tonumber(on)
      off = tonumber(off)
    end

    if vim[scope][prop] == on then
      vim[scope][prop] = off
    else
      vim[scope][prop] = on
    end
  end,
  {nargs = '*', bang = true, desc = 'Toggle vim option'}
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
  pattern = {'qf', 'help', 'man', 'lspinfo'},
  command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

if env.preserve_beam_cursor then
  autocmd('VimLeave', {group = augroup, command = 'set guicursor=a:ver25'})
end


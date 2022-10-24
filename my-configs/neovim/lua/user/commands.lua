local env = require('user.env')
local fns = require('user.functions')

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
      vim.cmd('silent! bufdo GuessIndent')
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
  'NullLsp',
  function()
    require('lsp.null-ls').setup()
  end,
  {desc = 'Initialize Null-ls'}
)

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

    local settings = require('user.projects')[name]

    if settings then
      settings(arg)
    end
  end,
  {desc = 'Use project settings', nargs = 1}
)

command(
  'EditMacro',
  function()
    local register = 'i'

    local opts = {default = vim.g.edit_macro_last or ''}

    if opts.default == '' then
      opts.prompt = 'Create Macro'
    else
      opts.prompt = 'Edit Macro'
    end

    vim.ui.input(opts, function(value)
      if value == nil then
        return
      end

      local macro = vim.fn.escape(value, '"')
      vim.cmd(string.format('let @%s="%s"', register, macro))

      vim.g.edit_macro_last = value
    end)
  end,
  {desc = 'Create/Edit macro in an input'}
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


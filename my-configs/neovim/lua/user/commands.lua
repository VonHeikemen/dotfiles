local env = require('user.env')

local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', {clear = true})

command(
  'LspEnable',
  function(input)
    require('user.diagnostics')

    vim.lsp.enable(input.fargs)
    local has_filetype = vim.bo.filetype ~= ''

    if has_filetype then
      vim.schedule(function() pcall(vim.api.nvim_command, 'edit') end)
    end
  end,
  {nargs = '*'}
)

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
  'ToggleOpt',
  function(input)
    local prop = input.fargs[1]
    local scope = input.fargs[2]
    local on =  input.fargs[3] --[[@as string | number?]]
    local off = input.fargs[4] --[[@as string | number?]]

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

command(
  'Termbg',
  function(input)
    -- g:sync_bg must be the original background color of the terminal
    if type(vim.g.sync_bg) ~= 'string' then
      vim.notify('[termbg] Must define g:sync_bg')
      return
    end

    local normal = vim.api.nvim_get_hl(0, {name = 'Normal'})
    if normal.bg == nil then
      return
    end

    local colors = {bg = normal.bg, reset = vim.g.sync_bg}

    local bg = function(run)
      if run == 'normal' then
        io.stdout:write(string.format('\027]11;#%06x\007', colors.bg))
        return
      end

      if run == 'reset' then
        io.stdout:write(string.format('\027]11;%s\007', colors.reset))
        return
      end
    end

    local group = vim.api.nvim_create_augroup('termbg_cmds', {clear = true})
    vim.api.nvim_create_autocmd({'ColorScheme', 'VimResume'}, {
      group = group,
      callback = function() bg('normal') end
    })
    vim.api.nvim_create_autocmd({'VimLeavePre', 'VimSuspend'}, {
      group = group,
      callback = function() bg('reset') end
    })

    if input.bang then
      bg('normal')
    end
  end,
  {desc = 'Sync terminal background with Neovim colorscheme', bang = true}
)

command(
  'GitPush',
  function()
    local branch = vim.fn.system({'git', 'branch', '--show-current'})
    branch = vim.trim(branch)

    if branch == '' then
      vim.notify('Could not retrieve branch name', vim.log.levels.ERROR)
      return
    end

    local remote = vim.fn.system({
      'git',
      'config',
      string.format('branch.%s.remote', branch)
    })

    if remote == '' then
      vim.notify('Could not find remote', vim.log.levels.ERROR)
      return
    end

    remote = vim.trim(remote)
    local value = string.format('%s %s', remote, branch)
    vim.ui.input({prompt = 'Git push', default = value}, function(input)
      if input == nil then
        vim.notify('Git push aborted', vim.log.levels.WARN)
        return
      end

      if value ~= input then
        vim.notify('Git push canceled', vim.log.levels.WARN)
        return
      end

      if vim.fn.exists(':Git') == 2 then
        local args = {'push', remote, branch}
        vim.cmd({cmd = 'Git', args = args})
        return
      end

      local cmd = {'git', 'push', remote, branch}
      local opts = {}
      opts.on_exit = function(_, code)
        if code ~= 0 then
          vim.notify('Git push failed', vim.log.levels.ERROR)
          return
        end

        vim.notify('Git push completed')
      end
      vim.fn.jobstart(cmd, opts)
    end)
  end,
  {desc = 'Git push with a confirm input'}
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
  pattern = {
    'qf', 'help', 'man', 'lspinfo',
    'checkhealth', 'mininotify-history'
  },
  command = 'nnoremap <buffer> q <cmd>close<cr>'
})

autocmd('LspAttach', {
  group = augroup,
  desc = 'disable semantic highlights',
  callback = function(event)
    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil then
      return
    end

    client.server_capabilities.semanticTokensProvider = nil
  end,
})

if env.preserve_beam_cursor then
  autocmd('VimLeave', {group = augroup, command = 'set guicursor=a:ver25'})
end


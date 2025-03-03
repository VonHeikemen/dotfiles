-- An asynchronous linter plugin
local Plugin = {'mfussenegger/nvim-lint'}

Plugin.cmd = {'Lint', 'LintSave'}

function Plugin.config()
  require('user.diagnostics')

  local augroup = vim.api.nvim_create_augroup('lint_cmds', {clear = true})
  local command = vim.api.nvim_create_user_command
  local autocmd = vim.api.nvim_create_autocmd

  command('Lint', function(input)
    local linter = input.args
    if linter == '' then
      linter = nil
    end

    require('lint').try_lint(linter)
  end, {nargs = '?'})

  command('LintSave', function(input)
    local name = input.fargs[1]
    local ft = input.fargs[2]
    local linter = (require('lint').linters[name] or {}).cmd
    local available = false

    if type(linter) == 'string' then
      available = vim.fn.executable(linter) == 1
    elseif type(linter) == 'function' then
      available = vim.fn.executable(linter()) == 1
    end

    if not available then
      return
    end

    autocmd('FileType', {
      pattern = ft,
      group = augroup,
      callback = function(event)
        vim.b.linter_attached = 1

        autocmd('BufWritePost', {
          group = augroup,
          buffer = event.buf,
          command = string.format('Lint %s', name)
        })
      end
    })
  end, {nargs = '*'})
end

return Plugin


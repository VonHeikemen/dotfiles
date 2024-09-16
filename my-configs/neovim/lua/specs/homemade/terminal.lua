local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'terminal'
Plugin.dir = vim.fs.joinpath(path, 'pack', Plugin.name)

function Plugin.config()
  vim.keymap.set({'n', 'i', 'x', 't'}, '<M-i>', '<cmd>ToggleShell<cr>')
  vim.keymap.set('n', '<leader>g', '<cmd>Tig<cr>')

  vim.keymap.set('t', '<C-w>w', '<C-w>')
  vim.keymap.set('t', '<C-w>o', '<C-\\><C-n><C-w>w')
  vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h')
  vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k')
  vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j')
  vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l')

  vim.keymap.set('t', '<C-o>t', '<C-\\><C-n>gt')
  vim.keymap.set('t', '<C-o>T', '<C-\\><C-n>gT')

  local toggle_shell = function(input)
    local env = require('user.env')
    local opts = {
      size = '30%',
      name = 'default_shell',
      display = 'split',
      direction = 'top',
    }

    if vim.o.lines < env.small_screen_lines then
      opts.display = 'split'
      opts.size = '40%'
      opts.direction = 'right'
    end

    require('terminal').toggle_shell(opts)
  end

  local tig_status = function()
    local env = require('user.env')

    local opts = {
      cmd = {'tig', 'status'},
    }

    local term = require('terminal')

    if vim.o.lines < env.small_screen_lines then
      term.tabnew(opts)
      return
    end

    term.float_term(opts)
  end

  local command = vim.api.nvim_create_user_command
  command('ToggleShell', toggle_shell, {nargs = '?'})
  command('Tig', tig_status, {})
end

return Plugin


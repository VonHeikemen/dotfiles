local path =  vim.fn.stdpath('config')

local Plugin = {}

Plugin.name = 'terminal'
Plugin.dir = vim.fs.joinpath(path, 'pack', Plugin.name)

function Plugin.config()
  vim.keymap.set({'n', 'i', 'x', 't'}, '<M-i>', '<cmd>Term<cr>')

  vim.keymap.set('t', '<C-w>w', '<C-w>')
  vim.keymap.set('t', '<C-w>o', '<C-\\><C-n><C-w>w')
  vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h')
  vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k')
  vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j')
  vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l')

  vim.keymap.set('t', '<C-o>t', '<C-\\><C-n>gt')
  vim.keymap.set('t', '<C-o>T', '<C-\\><C-n>gT')

  local on_open = function()
    local hl_term = vim.api.nvim_get_hl(0, {name = 'TermBg'})
    if hl_term.bg then
      vim.wo.winhighlight = 'Normal:TermBg,SignColumn:TermBg'
    end
  end

  local current_direction = 'top'
  local toggleterm = function(input)
    local env = require('user.env')
    local opts = {size = 0.3, direction = current_direction}

    if vim.o.lines < env.small_screen_lines then
      opts.size = 0.4
      opts.direction = 'right'
    end

    if input.args ~= '' then
      opts.direction = input.args
    end

    require('terminal').toggle(opts)

    current_direction = opts.direction
  end

  vim.api.nvim_create_user_command('Term', toggleterm, {nargs = '?'})

  require('terminal.settings').set({on_open = on_open})
end

return Plugin


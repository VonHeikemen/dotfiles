-- File explorer
local Plugin = {'tamago324/lir.nvim'}
Plugin.depends = {'nvim-lua/plenary.nvim'}

local user = {}
local small_screen = vim.g.env_small_screen or 19

function Plugin.init()
  -- disable netrw
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  local bind = vim.keymap.set
  local toggle = user.toggle

  -- Open file manager
  bind('n', '<leader>dd', '<cmd>FileExplorer<cr>')
  bind('n', '<leader>da', '<cmd>FileExplorer!<cr>')

  vim.api.nvim_create_user_command(
    'FileExplorer',
    function(input) toggle(input.args, input.bang) end,
    {bang = true, nargs = '?'}
  )
end

function Plugin.config()
  local lir = require('lir')

  local actions = require('lir.actions')
  local marks = require('lir.mark.actions')
  local clipboard = require('lir.clipboard.actions')

  lir.setup({
    on_init = user.on_init,
    mappings = {
      ['l']  = actions.edit,
      ['es'] = actions.split,
      ['ev'] = actions.vsplit,
      ['et'] = actions.tabedit,

      ['h']  = actions.up,
      ['q']  = actions.quit,

      ['za'] = actions.toggle_show_hidden,
      ['i'] = actions.newfile,
      ['o'] = actions.mkdir,
      ['d'] = actions.delete,
      ['Y'] = actions.yank_path,
      ['cl'] = actions.rename,

      ['<Tab>'] = marks.toggle_mark,

      ['cc'] = clipboard.copy,
      ['cx'] = clipboard.cut,
      ['cv'] = clipboard.paste,
    },
    float = {
      winblend = 0,
      win_opts = function()
        return {
          border = 'single',
          zindex = 46
        }
      end
    }
  })
end

function user.on_init()
  local noremap = {remap = false, silent = true, buffer = true}
  local remap = {remap = true, silent = true, buffer = true}
  local bind = vim.keymap.set

  local mark = "<esc><cmd>lua require('lir.mark.actions').toggle_mark('v')<cr>gv<C-c>"

  bind('n', 'v', 'V', noremap)
  bind('x', 'q', '<esc>', noremap)

  bind('x', '<Tab>', mark, noremap)
  bind('x', 'cc', mark .. 'cc', remap)
  bind('x', 'cx', mark .. 'cx', remap)

  bind('n', '<S-Tab>', 'gv<Tab>', remap)

  bind('n', 'ff', '<cmd>Telescope find_files<cr>', noremap)
end

function user.toggle(cwd, root)
  local path = ''

  if root then
    path = vim.fn.getcwd()
  elseif cwd == '' then
    path = vim.fn.expand('%:p:h')
  else
    path = cwd
  end

  if vim.o.lines > small_screen then
    require('lir.float').toggle(path)
  else
    vim.cmd({cmd = 'edit', args = {path}})
  end
end

return Plugin


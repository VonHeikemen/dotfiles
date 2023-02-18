-- File explorer
local Plugin = {'tamago324/lir.nvim'}

Plugin.dependencies = {
  {'nvim-lua/plenary.nvim'}
}

function Plugin.init()
  -- disable netrw
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  local fns = require('user.functions')
  local bind = vim.keymap.set

  -- Open file manager
  bind('n', '<leader>dd', fns.file_explorer)
  bind('n', '<leader>da', function() fns.file_explorer(vim.fn.getcwd()) end)
end

local function lir_init()
  local noremap = {remap = false, silent = true, buffer = true}
  local remap = {remap = true, silent = true, buffer = true}
  local bind = vim.keymap.set

  local mark = ":<C-u>lua require('lir.mark.actions').toggle_mark('v')<CR>gv<C-c>"

  bind('n', 'v', 'V', noremap)
  bind('x', 'q', '<Esc>', noremap)

  bind('x', '<Tab>', mark, noremap)
  bind('x', 'cc', mark .. 'cc', remap)
  bind('x', 'cx', mark .. 'cx', remap)

  bind('n', '<S-Tab>', 'gv<Tab>', remap)

  vim.wo.statusline = require('plugins.core.statusline').get_status('short')
end

function Plugin.config()
  local lir = require('lir')

  local actions = require('lir.actions')
  local marks = require('lir.mark.actions')
  local clipboard = require('lir.clipboard.actions')

  lir.setup({
    on_init = lir_init,
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
      ['r'] = actions.rename,
      ['d'] = actions.delete,
      ['Y'] = actions.yank_path,

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

return Plugin


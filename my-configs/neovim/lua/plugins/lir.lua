local lir = require('lir')

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local actions = require('lir.actions')
local marks = require('lir.mark.actions')
local clipboard = require('lir.clipboard.actions')
local bufmap = function(...) vim.api.nvim_buf_set_keymap(0, ...) end

local on_init = function()
  local noremap = {noremap = true, silent = true}
  local remap = {noremap = false, silent = true}

  local mark = ":<C-u>lua require('lir.mark.actions').toggle_mark('v')<CR>gv<C-c>"

  bufmap('n', 'v', 'V', noremap)
  bufmap('x', 'q', '<Esc>', noremap)

  bufmap('x', '<Tab>', mark, noremap)
  bufmap('x', 'cc', mark .. 'cc', remap)
  bufmap('x', 'cx', mark .. 'cx', remap)

  bufmap('n', '<S-Tab>', 'gv<Tab>', remap)
end

lir.setup({
  on_init = on_init,
  mappings = {
    ['l']  = actions.edit,
    ['es'] = actions.split,
    ['ev'] = actions.vsplit,
    ['et'] = actions.tabedit,

    ['h']  = actions.up,
    ['q']  = actions.quit,

    ['.'] = actions.toggle_show_hidden,
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
        border = 'single'
      }
    end
  }
})


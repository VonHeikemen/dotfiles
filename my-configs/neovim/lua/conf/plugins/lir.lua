local lir = require 'lir'

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local autocmd = require 'bridge'.augroup 'lir_settings'

local actions = require 'lir.actions'
local marks = require 'lir.mark.actions'
local clipboard = require 'lir.clipboard.actions'

autocmd({'filetype', 'lir'}, function()
  local k = vim.keymap
  local mark = ":<C-u>lua require 'lir.mark.actions'.toggle_mark('v')<CR>gv<C-c>"

  k.nnoremap {buffer = true, 'v', 'V'}
  k.xnoremap {buffer = true, 'q', '<Esc>'}

  k.xnoremap {buffer = true, silent = true, '<Tab>', mark}
  k.xmap {buffer = true, silent = true, 'cc', mark .. 'cc'}
  k.xmap {buffer = true, silent = true, 'cx', mark .. 'cx'}

  k.nmap {buffer = true, silent = true, '<S-Tab>', 'gv<Tab>'}
end)

lir.setup {
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
}


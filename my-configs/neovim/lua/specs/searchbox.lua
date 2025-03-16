-- Buffer search prompt
local Plugin = {'VonHeikemen/searchbox.nvim'}
Plugin.depends = {'MunifTanjim/nui.nvim'}

Plugin.cmd = {
  'SearchBoxIncSearch',
  'SearchBoxMatchAll',
  'SearchBoxReplace',
}

Plugin.opts = {
  defaults = {
    modifier = 'plain',
    confirm = 'native',
    show_matches = '[T:{total}]'
  },
  hooks = {
    after_mount = function(input)
      local opts = {buffer = input.bufnr}

      -- delete word
      vim.keymap.set('i', '<c-w>', '<c-s-w>', opts)
    end
  }
}

function Plugin.init()
  local bind = vim.keymap.set

  bind('n', 's', '<nop>')

  bind('n', 'sb', '<cmd>SearchBoxIncSearch<cr>')
  bind('x', 'sb', "<Esc><cmd>'<,'>SearchBoxIncSearch visual_mode=true<cr>")
  bind('n', 's+', "<cmd>exe 'SearchBoxIncSearch  --' expand('<cword>')<cr>")

  bind('n', 'sm', '<cmd>SearchBoxMatchAll<cr>')
  bind('x', 'sm', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxMatchAll --' getreg('/')<cr>")

  bind('n', 'sr', '<cmd>SearchBoxReplace<cr>')
  bind('x', 'sr', '<Esc><cmd>SearchBoxReplace  visual_mode=true<cr>')
  bind('n', 'sR', "<cmd>exe 'SearchBoxReplace  --' expand('<cword>')<cr>")
  bind('x', 'sR', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxReplace --' getreg('/')<cr>")

  -- Search in function (depends on nvim-treesitter-textobjects)
  bind('n', 'sif', 'vif<Esc><cmd>SearchBoxIncSearch modifier=":\\V\\%V"<cr>', {remap = true})
end

function Plugin.config(opts)
  require('searchbox').setup(opts)
end

return Plugin


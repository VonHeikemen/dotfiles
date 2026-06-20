-- Buffer search prompt
-- NOTE: depends on MunifTanjim/nui.nvim

local Plugin = {'VonHeikemen/searchbox.nvim'}

local env = vim.g.env or {}
local small_screen = env.small_screen or 19

Plugin.cmd = {
  'SearchBoxIncSearch',
  'SearchBoxMatchAll',
  'SearchBoxReplace',
  'Grep'
}

Plugin.opts = {
  defaults = {
    modifier = 'plain',
    confirm = 'native',
    show_matches = '[T:{total}]'
  },
  popup = {
    border = {style = 'rounded'},
  },
  grep_options = {
    executable = 'rg',
    flags = {'--vimgrep', '-uu'},
    quickfix_format = '%f:%l:%c:%m',
    quickfix_window = true,
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

  bind('n', 'sb', '<cmd>SearchBoxIncSearch<cr>')
  bind('x', 'sb', "<Esc><cmd>'<,'>SearchBoxIncSearch visual_mode=true<cr>")
  bind('n', 's+', "<cmd>exe 'SearchBoxIncSearch  --' expand('<cword>')<cr>")

  bind('n', 'sm', '<cmd>SearchBoxMatchAll<cr>')
  bind('x', 'sm', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxMatchAll --' getreg('/')<cr>")

  bind('n', 'sr', '<cmd>SearchBoxReplace<cr>')
  bind('x', 'sr', '<Esc><cmd>SearchBoxReplace  visual_mode=true<cr>')
  bind('n', 'sR', "<cmd>exe 'SearchBoxReplace  --' expand('<cword>')<cr>")
  bind('x', 'sR', "<Esc><cmd>GetSelection<cr><cmd>exe 'SearchBoxReplace --' getreg('/')<cr>")

  bind('n', '<leader>F', '<cmd>Grep<cr>')
  bind('x', '<leader>F', "<Esc><cmd>GetSelection<cr><cmd>exe 'Grep -F --' getreg('/')<cr>")
  bind('n', '<leader>fw', "<Esc><cmd>exe 'Grep -F --' expand('<cword>')<cr>")
end

function Plugin.config(opts)
  local searchbox = require('searchbox')
  
  if vim.o.lines < small_screen then
    opts.grep_options.quickfix_window = false
  end

  searchbox.setup(opts)

  vim.api.nvim_create_user_command('Grep', function(input)
    local query = input.args
    if #query > 0  then
      searchbox.run_grep(query)
      return
    end

    searchbox.grep({
      position_relative = 'editor',
      position_x = '50%',
      position_y = '15%',
      window_width = '45%',
    })
  end, {nargs = '?'})
end

return Plugin


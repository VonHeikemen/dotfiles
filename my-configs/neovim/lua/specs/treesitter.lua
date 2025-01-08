local Plugins = {}
local Plug = function(spec) table.insert(Plugins, spec) end

Plug {
  'nvim-treesitter/nvim-treesitter',
  rev = 'v0.9.3',
  user_event = {'LazySpec'},
  opts = {
    highlight = {
      enable = true,
      disable = {'vue'},
      additional_vim_regex_highlighting = {'html', 'vimdoc'},
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'ga',
        node_incremental = 'ga',
        node_decremental = 'gz',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['ia'] = '@parameter.inner',
        }
      },
      swap = {
        enable = true,
        swap_previous = {
          ['{a'] = '@parameter.inner',
        },
        swap_next = {
          ['}a'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']f'] = '@function.outer',
          [']c'] = '@class.outer',
          [']a'] = '@parameter.inner',
        },
        goto_next_end = {
          [']F'] = '@function.outer',
          [']C'] = '@class.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[c'] = '@class.outer',
          ['[a'] = '@parameter.inner',
        },
        goto_previous_end = {
          ['[F'] = '@function.outer',
          ['[C'] = '@class.outer',
        },
      },
    },
    ensure_installed = {
      'javascript',
      'typescript',
      'tsx',
      'php',
      'html',
      'twig',
      'css',
      'json',
      'lua',
      'vim',
      'vimdoc',
    },
  },
  update = function()
    vim.cmd('TSUpdate')
  end,
  config = function(opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}

Plug {
  'nvim-treesitter/nvim-treesitter-textobjects',
  depends = {'nvim-treesitter/nvim-treesitter'},
  rev = '3e450cd85243da99dc23ebbf14f9c70e9a0c26a4',
  user_event = {'LazySpec'},
}

return Plugins


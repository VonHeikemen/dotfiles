local ts = require 'nvim-treesitter.configs'

ts.setup {
  highlight = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ia"] = "@parameter.inner",
      }
    },
    swap = {
      enable = true,
      swap_previous = {
        ["{a"] = "@parameter.inner",
      },
      swap_next = {
        ["}a"] = "@parameter.inner",
      },
    }
  },
  ensure_installed = {
    'javascript',
    'typescript',
    'tsx',
    'php',
    'lua',
    'python',
  },
}


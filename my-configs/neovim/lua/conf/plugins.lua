local env = require 'conf.env'
local load = require 'conf.functions'.load_module

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

require 'paq' {
  -- Plugin manager
  {'savq/paq-nvim'},

  -- keymap DSL
  {'tjdevries/astronauta.nvim'},

  -- Fuzzy finder
  {'junegunn/fzf.vim', opt = true},
  {'zackhsi/fzf-tags', opt = true},

  -- Theme
  {'VonHeikemen/rubber-themes.vim', opt = true},

  -- Session manager
  {'tpope/vim-obsession', opt = true},

  -- Better clipboard support
  {'christoomey/vim-system-copy'},

  -- Editor config
  {'editorconfig/editorconfig-vim', opt = true},

  -- Autocompletion
  {'hrsh7th/nvim-compe', opt = true},

  -- Snippets
  {'L3MON4D3/LuaSnip', opt = true},
  {'rafamadriz/friendly-snippets', opt = true},
  {'windwp/nvim-autopairs', opt = true},
  {'b3nj5m1n/kommentary', opt = true},
  {'mattn/emmet-vim', opt = true},

  -- Syntax highlight
  {'othree/html5.vim'},
  {'pangloss/vim-javascript'},
  {'lumiliet/vim-twig'},
  {
    'nvim-treesitter/nvim-treesitter',
    opt = true,
    run = function()
      vim.cmd('TSUpdate')
    end
  },

  --  Utilities
  {'moll/vim-bbye', opt = true},
  {'wellle/targets.vim', opt = true},
  {'tpope/vim-surround', opt = true},
  {'tpope/vim-repeat', opt = true},
  {'tpope/vim-abolish', opt = true},
  {'ggandor/lightspeed.nvim', opt = true},
  {'romainl/vim-qf', opt = true},
  {'stefandtw/quickfix-reflector.vim', opt = true},
  {'nvim-treesitter/playground', opt = true},
  {'nvim-treesitter/nvim-treesitter-textobjects', opt = true},
  {'nvim-lua/plenary.nvim'},
}

-- ========================================================================== --
-- ==                                CONFIG                                == --
-- ========================================================================== --

-- FZF
--
vim.opt.runtimepath:append(env.fzf_path)

vim.env.FZF_DEFAULT_OPTS = '--layout=reverse'

vim.g.fzf_preview_window = {}
vim.g.fzf_layout = {
  window = {
    height = 0.6,
    width = 0.9
  }
}

-- kommentary
--
load('kommentary.config', function(kommentary) 
  kommentary.configure_language("default", {
    prefer_single_line_comments = true,
  })
end)

--nvim-autopairs
--
load('nvim-autopairs', function(npairs)
  npairs.setup {
    fast_wrap = {}
  }
end)

-- LuaSnip
--
load('luasnip/loaders/from_vscode', function(luasnip)
  luasnip.lazy_load()
end)

-- nvim-compe
--
load('compe', function(compe)
  compe.setup {
    enable = true,
    autocomplete = false,
    source = {
      path = true,
      luasnip = true,
      buffer = true,
      tags = true,
    }
  }
end)

-- Treesitter
--
load('nvim-treesitter.configs', function(ts)
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
end)


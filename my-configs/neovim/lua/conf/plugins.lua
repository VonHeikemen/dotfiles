local env = require 'conf.env'
local load = require 'plug'.load_module
local init = require 'plug'.init_plugins

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

init {
  -- Plugin manager
  {'savq/paq-nvim', type = 'start'},

  -- keymap DSL
  {'tjdevries/astronauta.nvim', type = 'start'},

  -- Fuzzy finder
  {'junegunn/fzf.vim'},
  {'zackhsi/fzf-tags'},

  -- Theme
  {'VonHeikemen/rubber-themes.vim', type = 'opt'},

  -- Session manager
  {'tpope/vim-obsession'},

  -- Distraction free mode
  {'folke/zen-mode.nvim', type = 'start'},

  -- File explorer
  {'cocopon/vaffle.vim'},

  -- Better clipboard support
  {'christoomey/vim-system-copy', type = 'start'},

  -- Editor config
  {'editorconfig/editorconfig-vim', type = 'opt'},

  -- Autocompletion
  {'hrsh7th/nvim-compe'},

  -- Snippets
  {'L3MON4D3/LuaSnip'},
  {'rafamadriz/friendly-snippets', type = 'start'},
  {'windwp/nvim-autopairs'},
  {'b3nj5m1n/kommentary'},
  {'mattn/emmet-vim', type = 'opt'},

  -- Language support
  {'othree/html5.vim', type = 'start'},
  {'pangloss/vim-javascript', type = 'start'},
  {'lumiliet/vim-twig', type = 'start'},
  {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd 'TSUpdate' end
  },
  {'nvim-treesitter/nvim-treesitter-textobjects'},

  --  Utilities
  {'moll/vim-bbye'},
  {'wellle/targets.vim'},
  {'tpope/vim-surround'},
  {'tpope/vim-repeat'},
  {'tpope/vim-abolish'},
  {'ggandor/lightspeed.nvim'},
  {'romainl/vim-qf'},
  {'stefandtw/quickfix-reflector.vim'},
  {'nvim-treesitter/playground', type = 'opt'},
  {'nvim-lua/plenary.nvim', type = 'start'},
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

-- nvim-autopairs
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
  luasnip.load({ include = { vim.bo.filetype } })
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
    indent = {
      enable = true
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

-- zen-mode.nvim
--
load('zen-mode', function(zen)
  zen.setup {
    window = {
      width = 0.60,
      height = 1
    },
    on_open = function(win)
      vim.opt.wrap = true
      vim.keymap.noremap {buffer = true, 'k', 'gk'}
      vim.keymap.noremap {buffer = true, 'j', 'gj'}
    end
  }
end)


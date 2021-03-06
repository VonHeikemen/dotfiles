local env = require 'conf.env'
local load = require 'plug'.load_module
local init = require 'plug'.init_plugins
local lua_expr = require 'bridge'.lua_expr
local create_excmd = require 'bridge'.create_excmd

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

init {
  -- Plugin manager
  {'k-takata/minpac', type = 'opt'},

  -- keymap DSL
  {'tjdevries/astronauta.nvim', type = 'start'},

  -- Fuzzy finder
  {'junegunn/fzf.vim'},
  {'zackhsi/fzf-tags'},
  {'nvim-telescope/telescope.nvim'},
  {'nvim-telescope/telescope-fzf-native.nvim', run = 'silent! !make'},

  -- Theme
  {'VonHeikemen/rubber-themes.vim', type = 'opt'},

  -- Session manager
  {'tpope/vim-obsession'},

  -- Distraction free mode
  {'folke/zen-mode.nvim', type = 'start'},

  -- File explorer
  {'cocopon/vaffle.vim', type = 'start'},

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
    run = function() pcall(vim.cmd, 'TSUpdate') end
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
  {'nvim-lua/popup.nvim', type = 'start'},
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
  kommentary.configure_language('default', {
    prefer_single_line_comments = true,
  })
  kommentary.configure_language('php', {
    single_line_comment_string = '//'
  })
end)

-- nvim-autopairs
--
load('nvim-autopairs', function(npairs)
  npairs.setup {
    fast_wrap = {}
  }

  vim.keymap.inoremap {expr = true, '<CR>', lua_expr(npairs.autopairs_cr)}
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
      vim.opt.linebreak = true
      vim.keymap.noremap {buffer = true, 'k', 'gk'}
      vim.keymap.noremap {buffer = true, 'j', 'gj'}
    end
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

-- telescope.nvim
--
load('telescope', function(telescope)
  local actions = require 'telescope.actions'

  vim.cmd [[
    hi! link TelescopeMatching Boolean
    hi! link TelescopeSelection CursorLine
    hi! TelescopeSelectionCaret guifg=#FC8680 guibg=#242830
  ]]

  create_excmd('TGrep', {user_input = true, function(input)
    require 'telescope.builtin'.grep_string({search = input})
  end})

  telescope.setup {
    defaults = {
      prompt_prefix = ' ',
      selection_caret = '❯ ',
      mappings = {
        i = {
          ['<esc>'] = actions.close,
          ['<C-k>'] = actions.move_selection_previous,
          ['<C-j>'] = actions.move_selection_next,
        }
      }
    },
    pickers = {
      buffers = {
        previewer = false,
        theme = 'dropdown'
      },
      find_files = {
        previewer = false,
        theme = 'dropdown'
      },
      file_browser = {
        previewer = false,
        theme = 'dropdown'
      },
      grep_string = {
        prompt_title = 'Search',
        sorting_strategy = 'ascending',
        layout_config = {
          prompt_position = 'top'
        }
      },
      treesitter = {
        prompt_title = 'Buffer Symbols',
        sorting_strategy = 'ascending',
        layout_config = {
          prompt_position = 'top'
        }
      },
      oldfiles = {
        prompt_title = 'History',
        previewer = false,
        theme = 'dropdown'
      },
      file_browser = {
        disable_devicons = true,
        previewer = false,
        theme = 'dropdown'
      },
      commands = {
        theme = 'dropdown'
      },
      keymaps = {
        theme = 'dropdown'
      }
    },
    extension = {
      fuzzy = false,
      override_generic_sorter = true,
      override_file_sorter = true,
    }
  }

  telescope.load_extension('fzf')
end)


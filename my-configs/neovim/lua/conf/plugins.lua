local fns = require('conf.functions')
local plug = require('plug')

local lua_expr = require('bridge').lua_expr

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

plug.init({
  -- Plugin manager
  {'k-takata/minpac', type = 'opt'},

  -- keymap DSL
  {'tjdevries/astronauta.nvim', type = 'start'},

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    type = 'start',
    config = function() fns.nvim_ready('conf.plugins.telescope') end
  },
  {
    'nvim-telescope/telescope-fzy-native.nvim',
    type = 'start',
    depth = 2,
    run = function()
      vim.fn.jobstart({'make'}, {
        cwd = vim.fn.getcwd() .. '/deps/fzy-lua-native',
        on_stdout = fns.job_output,
      })
    end
  },

  -- Theme
  {'VonHeikemen/rubber-themes.vim', type = 'opt'},

  -- Session manager
  {'tpope/vim-obsession'},

  -- Distraction free mode
  {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup({
        window = {
          width = 0.60,
          height = 0.98
        },
        on_open = function(win)
          vim.opt.wrap = true
          vim.opt.linebreak = true
          vim.keymap.nnoremap {buffer = true, 'k', 'gk'}
          vim.keymap.nnoremap {buffer = true, 'j', 'gj'}
        end
      })
    end
  },

  -- File explorer
  {
    'tamago324/lir.nvim',
    type = 'start',
    config = function() require('conf.plugins.lir') end
  },

  -- Better clipboard support
  {'christoomey/vim-system-copy'},

  -- Editor config
  {'editorconfig/editorconfig-vim', type = 'opt'},

  -- Autocompletion
  {
    'hrsh7th/nvim-compe',
    config = function()
      require('compe').setup({
        enable = true,
        autocomplete = false,
        source = {
          path = {priority = 3},
          buffer = {priority = 2},
          luasnip = {priority = 1},
        }
      })
    end
  },

  -- Snippets
  {'VonHeikemen/the-good-snippets', type = 'start'},
  {'mattn/emmet-vim', type = 'opt'},
  {
    'L3MON4D3/LuaSnip',
    config = function()
      local luasnip = require('luasnip/loaders/from_vscode')

      luasnip.lazy_load()
      luasnip.load({include = {vim.bo.filetype}})
    end
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      local npairs = require('nvim-autopairs')
      npairs.setup({fast_wrap = {}})

      vim.keymap.inoremap {
        expr = true,
        '<CR>',
        lua_expr(npairs.autopairs_cr)
      }
    end
  },
  {
    'b3nj5m1n/kommentary',
    config = function()
      local cfg = require('kommentary.config')

      cfg.configure_language('default', {
        prefer_single_line_comments = true,
      })
      cfg.configure_language('php', {
        single_line_comment_string = '//'
      })
      cfg.configure_language('python', {
        single_line_comment_string = '#'
      })
    end
  },

  -- Language support
  {'othree/html5.vim', type = 'start'},
  {'pangloss/vim-javascript', type = 'start'},
  {'lumiliet/vim-twig', type = 'start'},
  {
    'nvim-treesitter/nvim-treesitter',
    type = 'lazy',
    branch = '0.5-compat',
    run = function() pcall(vim.cmd, 'TSUpdate') end,
    config = function() require('conf.plugins.treesitter') end
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    type = 'lazy',
    branch = '0.5-compat'
  },

  --  Utilities
  {'moll/vim-bbye'},
  {'wellle/targets.vim'},
  {'tpope/vim-surround'},
  {'tpope/vim-repeat'},
  {'tpope/vim-abolish'},
  {'ggandor/lightspeed.nvim'},
  {'romainl/vim-qf'},
  {'stefandtw/quickfix-reflector.vim'},
  {
    'kevinhwang91/nvim-bqf',
    config = function()
      require('bqf').setup({auto_enable = false})
    end
  },
  {'nvim-treesitter/playground', type = 'opt'},
  {'nvim-lua/plenary.nvim', type = 'start'},
  {'nvim-lua/popup.nvim', type = 'start'},
})


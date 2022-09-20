local fns = require('user.functions')
local plug = require('plugins.manager')

local function use(mod) return function() require(mod) end end

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

plug.init({
  -- Plugin manager
  {'k-takata/minpac', type = 'opt'},

  -- Fuzzy finder
  {'nvim-telescope/telescope.nvim', config = use('plugins.telescope')},
  {
    'nvim-telescope/telescope-fzy-native.nvim',
    type = 'start',
    depth = 2,
    run = function()
      if vim.fn.executable('make') == 0 then return end

      vim.fn.jobstart({'make'}, {
        cwd = vim.fn.getcwd() .. '/deps/fzy-lua-native',
        on_stdout = fns.job_output,
      })
    end
  },

  -- Search
  {'dyng/ctrlsf.vim', config = use('plugins.ctrlsf')},

  -- Theme
  {'VonHeikemen/little-wonder', type = 'start'},

  -- Distraction free mode
  {'junegunn/goyo.vim', config = use('plugins.goyo')},

  -- File explorer
  {'tamago324/lir.nvim', type = 'start', config = use('plugins.lir')},

  -- Better clipboard support
  {'christoomey/vim-system-copy'},

  -- Editor config
  {'editorconfig/editorconfig-vim'},

  -- Autocompletion
  {'hrsh7th/nvim-cmp', config = use('plugins.nvim-cmp')},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'saadparwaiz1/cmp_luasnip'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-nvim-lua'},

  -- Snippets
  {'VonHeikemen/the-good-snippets', type = 'start'},
  {'mattn/emmet-vim', type = 'opt'},
  {'L3MON4D3/LuaSnip', config = use('plugins.luasnip')},
  {'windwp/nvim-autopairs', config = use('plugins.autopairs')},
  {'numToStr/Comment.nvim', config = use('plugins.comment')},

  -- Language support
  {'othree/html5.vim', type = 'start'},
  {'pangloss/vim-javascript', type = 'start'},
  {'lumiliet/vim-twig', type = 'start'},
  {
    'nvim-treesitter/nvim-treesitter',
    frozen = true,
    run = function() pcall(vim.cmd, 'TSUpdate') end,
    config = use('plugins.treesitter')
  },
  {'nvim-treesitter/nvim-treesitter-textobjects', frozen = true},

  -- LSP support
  {'williamboman/mason.nvim', type = 'opt'},
  {'jose-elias-alvarez/null-ls.nvim', type = 'opt'},
  {'j-hui/fidget.nvim', type = 'opt'},

  -- Git
  {'TimUntersberger/neogit', type = 'opt', config = use('plugins.neogit')},
  {'sindrets/diffview.nvim', type = 'opt'},
  {'rhysd/conflict-marker.vim'},

  -- Enhance quickfix list
  {'romainl/vim-qf'},

  -- Startup screen
  {'goolord/alpha-nvim', type = 'start', config = use('plugins.alpha')},

  -- UI components
  {'MunifTanjim/nui.nvim', type = 'start', config = use('plugins.vim-ui')},
  {'VonHeikemen/fine-cmdline.nvim', config = use('plugins.fine-cmdline')},
  {'VonHeikemen/searchbox.nvim', config = use('plugins.searchbox')},
  {'rcarriga/nvim-notify', config = use('plugins.nvim-notify')},
  {
    'lukas-reineke/indent-blankline.nvim',
    config = use('plugins.indent-blankline')
  },

  -- Handle terminal windows
  {'akinsho/toggleterm.nvim', config = use('plugins.toggleterm')},

  --  Utilities
  {'moll/vim-bbye'},
  {'wellle/targets.vim'},
  {'tpope/vim-surround', config = use('plugins.surround')},
  {'tpope/vim-repeat'},
  {'tpope/vim-abolish'},
  {'ThePrimeagen/harpoon'},
  {'nvim-treesitter/playground', type = 'opt'},
  {'nvim-lua/plenary.nvim', type = 'start'},
  {'NMAC427/guess-indent.nvim', config = use('plugins.guess-indent')},
  {'max397574/better-escape.nvim', config = use('plugins.better-escape')},
  {'ggandor/leap.nvim', config = use('plugins.leap')},
  {'ggandor/flit.nvim', config = use('plugins.flit')},
  {
    'VonHeikemen/project-settings.nvim',
    type = 'start',
    config = use('plugins.project-settings')
  }
})

-- ========================================================================== --
-- ==                            LOCAL PLUGINS                             == --
-- ========================================================================== --

require('plugins.tmux')
require('plugins.session')
require('plugins.statusline').setup('full')


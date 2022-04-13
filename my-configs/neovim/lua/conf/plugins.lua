local fns = require('conf.functions')
local setup = require('plugins.misc')
local plug = require('plug')

local nvim_ready = function(arg) return function() fns.nvim_ready(arg) end end
local use = function(mod) return function() require(mod) end end

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

plug.init({
  -- Plugin manager
  {'k-takata/minpac', type = 'opt'},

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    type = 'start',
    config = nvim_ready('plugins.telescope')
  },
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

  -- Theme
  {'VonHeikemen/rubber-themes.vim', type = 'opt'},
  {'VonHeikemen/little-wonder', type = 'start'},

  -- Session manager
  {
    'folke/persistence.nvim',
    type = 'start',
    config = use('plugins.persistence')
  },

  -- Distraction free mode
  {'folke/zen-mode.nvim', config = use('plugins.zen-mode')},

  -- File explorer
  {
    'tamago324/lir.nvim',
    type = 'start',
    config = use('plugins.lir')
  },

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
  {'windwp/nvim-autopairs', config = setup.autopairs},
  {'b3nj5m1n/kommentary', config = setup.kommentary},

  -- Language support
  {'othree/html5.vim', type = 'start'},
  {'pangloss/vim-javascript', type = 'start'},
  {'lumiliet/vim-twig', type = 'start'},
  {
    'nvim-treesitter/nvim-treesitter',
    type = 'lazy',
    frozen = true,
    run = function() pcall(vim.cmd, 'TSUpdate') end,
    config = use('plugins.treesitter')
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    type = 'lazy',
    frozen = true,
  },

  -- LSP support
  {'neovim/nvim-lspconfig', type = 'start'},
  {'williamboman/nvim-lsp-installer', type = 'opt'},
  {'VonHeikemen/lsp-zero.nvim', type = 'opt'},
  {'j-hui/fidget.nvim', type = 'opt'},

  -- Enhance quickfix list
  {'romainl/vim-qf'},
  {'stefandtw/quickfix-reflector.vim'},

  -- Startup screen
  {
    'goolord/alpha-nvim',
    type = 'start',
    config = use('plugins.alpha')
  },

  -- UI components
  {
    'MunifTanjim/nui.nvim',
    type = 'start',
    config = nvim_ready('plugins.vim-ui')
  },
  {
    'VonHeikemen/fine-cmdline.nvim',
    type = 'start',
    config = nvim_ready(setup.fine_cmdline)
  },
  {'VonHeikemen/searchbox.nvim', config = setup.searchbox},
  {'rcarriga/nvim-notify', config = setup.nvim_notify},

  --  Utilities
  {'moll/vim-bbye'},
  {'wellle/targets.vim'},
  {'tpope/vim-surround'},
  {'tpope/vim-repeat'},
  {'tpope/vim-abolish'},
  {'nvim-treesitter/playground', type = 'opt'},
  {'nvim-lua/plenary.nvim', type = 'start'},
  {'nvim-lua/popup.nvim', type = 'start'},
  {'NMAC427/guess-indent.nvim', config = setup.guess_indent},
  {'ggandor/lightspeed.nvim', config = setup.lightspeed},
  {
    'VonHeikemen/project-settings.nvim',
    type = 'start',
    config = use('plugins.project-settings')
  }
})


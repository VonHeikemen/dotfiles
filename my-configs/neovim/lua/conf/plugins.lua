local fns = require('conf.functions')
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
    config = nvim_ready('conf.plugins.telescope')
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
          local bufmap = function(lhs, rhs)
            vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {noremap = true})
          end
          vim.opt.wrap = true
          vim.opt.linebreak = true

          bufmap('n', 'k', 'gk')
          bufmap('n', 'j', 'gj')
          bufmap('x', 'k', 'gk')
          bufmap('x', 'j', 'gj')
          bufmap('n', 'O', 'O<Enter><Up>')
        end
      })
    end
  },

  -- File explorer
  {
    'tamago324/lir.nvim',
    type = 'start',
    config = use('conf.plugins.lir')
  },

  -- Better clipboard support
  {'christoomey/vim-system-copy'},

  -- Editor config
  {'editorconfig/editorconfig-vim', type = 'opt'},

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    config = use('conf.plugins.nvim-cmp')
  },
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'saadparwaiz1/cmp_luasnip'},

  -- Snippets
  {'VonHeikemen/the-good-snippets', type = 'start'},
  {'mattn/emmet-vim', type = 'opt'},
  {
    'L3MON4D3/LuaSnip',
    config = function()
      local luasnip = require('luasnip')
      local snippets = require('luasnip.loaders.from_vscode')

      luasnip.config.set_config({
        region_check_events = 'InsertEnter',
        delete_check_events = 'InsertLeave'
      })

      snippets.load()
    end
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      local npairs = require('nvim-autopairs')
      npairs.setup({fast_wrap = {}})
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
    config = use('conf.plugins.treesitter')
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    type = 'lazy',
    branch = '0.5-compat'
  },

  -- Enhance quickfix list
  {'romainl/vim-qf'},
  {'stefandtw/quickfix-reflector.vim'},

  -- UI components
  {
    'MunifTanjim/nui.nvim',
    type = 'start',
    config = nvim_ready('conf.plugins.vim-ui')
  },
  {
    'VonHeikemen/fine-cmdline.nvim',
    type = 'start',
    config = nvim_ready(function()
      require('fine-cmdline').setup({
        cmdline = {
          prompt = ' '
        }
      })
    end)
  },
  {
    'VonHeikemen/searchbox.nvim',
    config = function()
      require('searchbox').setup({
        hooks = {
          on_done = function(value)
            if value == nil then return end
            vim.fn.setreg('s', value)
          end
        }
      })
    end
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
      vim.notify.setup({
        stages = 'slide',
        background_colour = vim.g.terminal_color_background,
        minimum_width = 15
      })
    end
  },

  --  Utilities
  {'moll/vim-bbye'},
  {'wellle/targets.vim'},
  {'tpope/vim-surround'},
  {'tpope/vim-repeat'},
  {'tpope/vim-abolish'},
  {'nvim-treesitter/playground', type = 'opt'},
  {'nvim-lua/plenary.nvim', type = 'start'},
  {'nvim-lua/popup.nvim', type = 'start'},
  {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup({
        limit_ft_matches = 0,
        jump_to_unique_chars = false,
        exit_after_idle_msecs = {labeled = nil, unlabeled = 600},
        safe_labels = {},
        labels = {
          'w', 'f', 'n',
          'j', 'k', 'l', 'o', 'i', 'q', 'e', 'h', 'g',
          'u', 't',
          'm', 'v', 'c', 'a', '.', 'z',
          '/', 'F', 'L', 'N', 'H', 'G', 'M', 'U', 'T', '?', 'Z',
        },
      })
    end
  },
})


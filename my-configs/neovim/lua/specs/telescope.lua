-- Fuzzy Finder
local Plugin = {'nvim-telescope/telescope.nvim'}
Plugin.depends = {
  'nvim-lua/plenary.nvim',
  'natecraddock/telescope-zf-native.nvim',
}

Plugin.user_event = {'SpecDefer'}

function Plugin.opts(actions)
  local function defaults(title)
    return {
      prompt_title = title,
      results_title = false
    }
  end

  local function dropdown(title, previewer)
    return {
      prompt_title = title,
      previewer = previewer or false,
      theme = 'dropdown'
    }
  end

  return {
    defaults = {
      mappings = {
        i = {
          ['<esc>'] = actions.close,
          ['<M-k>'] = actions.move_selection_previous,
          ['<M-j>'] = actions.move_selection_next,
          ['<M-b>'] = actions.select_default,
        },
      },

      -- Default layout options
      prompt_prefix = ' ',
      selection_caret = '❯ ',
      layout_strategy = 'vertical',
      sorting_strategy = 'ascending',
      layout_config = {
        preview_cutoff = 25,
        mirror = true,
        prompt_position = 'top'
      },
    },
    pickers = {
      find_files = dropdown(),
      oldfiles = dropdown('History'),
      keymaps = dropdown(),
      command_history = dropdown(),
      colorscheme = dropdown(),

      grep_string = defaults('Search'),
      treesitter = defaults('Buffer Symbols'),
      current_buffer_fuzzy_find = defaults('Lines'),
      live_grep = defaults('Grep'),

      commands = defaults(),
      help_tags = defaults(),

      buffers = {
        theme = 'dropdown',
        previewer = false,
        mappings = {
          n = {
            ['dd'] = actions.delete_buffer,
          }
        }
      },
    },
  }
end

function Plugin.init()
  local bind = vim.keymap.set

  -- Search pattern
  bind('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')

  -- Show key bindings list
  bind('n', '<leader>?', '<cmd>Telescope keymaps<cr>')

  -- Find files by name
  bind('n', '<leader>ff', '<cmd>Telescope find_files<cr>')

  -- Search symbols in buffer
  bind('n', '<leader>fs', '<cmd>Telescope treesitter<cr>')

  -- Search buffer lines
  bind('n', '<leader>fb', '<cmd>Telescope current_buffer_fuzzy_find<cr>')

  -- Search in files history
  bind('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>')

  -- Search in active buffers list
  bind('n', '<leader>bb', '<cmd>Telescope buffers<cr>')
end

function Plugin.config(opts)
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  local command = vim.api.nvim_create_user_command

  command('TGrep', function(input)
    require('telescope.builtin').grep_string({search = input.args})
  end, {nargs = 1})

  telescope.setup(opts(actions))
  telescope.load_extension('zf-native')
end

return Plugin


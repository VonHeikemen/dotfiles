local command = vim.api.nvim_create_user_command
local bind = vim.keymap.set

local telescope = require('telescope')
local actions = require('telescope.actions')

command('TGrep', function(input)
  require('telescope.builtin').grep_string({search = input.args})
end, {nargs = 1})

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

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
      }
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
    buffers = dropdown(),
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
  },
  extension = {
    fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true
    },
  }
})

telescope.load_extension('fzy_native')

---
-- Keymaps
---

-- Search pattern
bind('n', '<leader>fg', ':Telescope live_grep<CR>')

-- Show key bindings list
bind('n', '<Leader>?', ':Telescope keymaps<CR>')

-- Find files by name
bind('n', '<Leader>ff', ':Telescope find_files<CR>')

-- Search symbols in buffer
bind('n', '<Leader>fs', ':Telescope treesitter<CR>')

-- Search buffer lines
bind('n', '<Leader>fb', ':Telescope current_buffer_fuzzy_find<CR>')

-- Search in files history
bind('n', '<Leader>fh', ':Telescope oldfiles<CR>')

-- Search in active buffers list
bind('n', '<Leader>bb', ':Telescope buffers<CR>')


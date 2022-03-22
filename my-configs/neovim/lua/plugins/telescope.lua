local create_excmd = require('bridge').create_excmd

local telescope = require('telescope')
local actions = require('telescope.actions')

create_excmd({'TGrep', qargs = true}, function(input)
  require('telescope.builtin').grep_string({search = input})
end)

local defaults = function(title)
  return {
    prompt_title = title,
    results_title = false
  }
end

local dropdown = function(title, previewer)
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


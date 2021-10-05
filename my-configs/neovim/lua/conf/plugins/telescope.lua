local create_excmd = require 'bridge'.create_excmd

local telescope = require 'telescope'
local actions = require 'telescope.actions'

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
      layout_strategy = 'vertical',
      layout_config = {
        preview_cutoff = 20,
        mirror = true
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
    keymaps = {
      theme = 'dropdown'
    }
  },
  extension = {
    fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true
    },
  }
}

telescope.load_extension('fzy_native')


-- Git
local Plugin = {'TimUntersberger/neogit'}
local user = {}

Plugin.name = 'neogit'

Plugin.dependencies = {
  {
    'sindrets/diffview.nvim',
    cmd = {'DiffviewOpen'},
    config = user.diffview,
  }
}

Plugin.keys = {{'<leader>g', '<cmd>Neogit<cr>'}}

Plugin.opts = {
  disable_hint = true,
  auto_refresh = false,
  integrations = {diffview = true},
  signs = {
    section = {'»', '-'},
    item = {'+', '*'}
  },
  mappings = {
    status = {
      [';'] = 'RefreshBuffer'
    }
  }
}

function user.diffview()
  local diff = require('diffview.actions')

  require('diffview').setup({
    use_icons = false,
    view = {
      default = {
        layout = 'diff2_vertical',
      },
      merge_tool = {
        layout = 'diff3_mixed',
      }
    },
    keymaps = {
      view = {
        {'n', '<M-h>', diff.conflict_choose('ours'), {desc = 'Choose ours'}},
        {'n', '<M-l>', diff.conflict_choose('theirs'), {desc = 'Choose theirs'}},
        {'n', '<M-j>', diff.next_conflict, {desc = 'Go to next conflict'}},
        {'n', '<M-k>', diff.prev_conflict, {desc = 'Go to previous conflict'}},
      }
    },
  })
end

return Plugin


-- Git
local Plugin = {'NeogitOrg/neogit'}
local user = {}

Plugin.dependencies = {
  {'nvim-lua/plenary.nvim'},
  {'nvim-telescope/telescope.nvim'},
  {
    'sindrets/diffview.nvim',
    cmd = {'DiffviewOpen'},
    config = function() user.diffview() end,
  }
}

Plugin.cmd = 'Neogit'

Plugin.keys = {{'<leader>g', '<cmd>Neogit<cr>'}}

Plugin.opts = {
  disable_hint = true,
  auto_refresh = false,
  disable_context_highlighting = true,
  integrations = {
    telescope = true,
    diffview = true
  },
  signs = {
    section = {'»', '-'},
    item = {'+', '*'}
  },
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


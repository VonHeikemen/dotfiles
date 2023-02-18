-- Git
local Plugin = {'TimUntersberger/neogit'}

Plugin.dependencies = {{'sindrets/diffview.nvim'}}

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

function Plugin.config(_, opts)
  require('diffview').setup({
    use_icons = false
  })

  require('neogit').setup(opts)
end

return Plugin


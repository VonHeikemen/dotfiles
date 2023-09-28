-- Indent guides
local Plugin = {'lukas-reineke/indent-blankline.nvim'}

Plugin.version = '3.x'

Plugin.main = 'ibl'

Plugin.event = {'BufReadPost', 'BufNewFile'}

Plugin.opts = {
  enabled = false,
  scope = {
    enabled = false,
  },
  indent = {
    char = '▏',
  },
}

function Plugin.init()
  vim.keymap.set('n', '<leader>ui', '<cmd>IBLToggle<cr>')
end

return Plugin


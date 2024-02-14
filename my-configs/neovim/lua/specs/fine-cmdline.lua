-- Command line prompt
local Plugin = {'VonHeikemen/fine-cmdline.nvim'}

Plugin.dependencies = {{'MunifTanjim/nui.nvim'}}

Plugin.opts = {
  cmdline = {
    prompt = ' '
  },
}

Plugin.cmd = 'FineCmdline'

function Plugin.init()
  vim.keymap.set('n', '<cr>', '<cmd>FineCmdline<cr>')
  vim.keymap.set('x', '<cr>', "<Esc><cmd>FineCmdline '<,'><cr>")
end

return Plugin


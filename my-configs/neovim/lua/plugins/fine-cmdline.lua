-- Command line prompt
local Plugin = {'VonHeikemen/fine-cmdline.nvim'}

Plugin.dependencies = {{'MunifTanjim/nui.nvim'}}

Plugin.name = 'fine-cmdline'

Plugin.opts = {
  cmdline = {
    prompt = ' '
  },
}

Plugin.cmd = 'FineCmdline'

function Plugin.init()
  vim.keymap.set('n', '<CR>', ':FineCmdline<CR>')
  vim.keymap.set('x', '<CR>', ":<C-u>FineCmdline '<,'><CR>")
end

return Plugin


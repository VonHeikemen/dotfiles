-- Command line prompt
local Plugin = {'VonHeikemen/fine-cmdline.nvim'}
Plugin.depends = {'MunifTanjim/nui.nvim'}

Plugin.cmd = {'FineCmdline'}

Plugin.opts = {
  cmdline = {
    prompt = ' '
  },
}

function Plugin.init()
  vim.keymap.set('n', '<cr>', '<cmd>FineCmdline<cr>')
  vim.keymap.set('x', '<cr>', "<Esc><cmd>FineCmdline '<,'><cr>")
end

function Plugin.config(opts)
  require('fine-cmdline').setup(opts)
end

return Plugin


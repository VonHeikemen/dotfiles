-- Command line prompt
local Plugin = {'VonHeikemen/fine-cmdline.nvim'}
Plugin.depends = {'MunifTanjim/nui.nvim'}

Plugin.cmd = {'FineCmdline'}

function Plugin.init()
  vim.keymap.set('n', '<cr>', '<cmd>FineCmdline<cr>')
  vim.keymap.set('x', '<cr>', "<Esc><cmd>FineCmdline '<,'><cr>")
end

function Plugin.config()
  require('fine-cmdline').setup({
    cmdline = {
      prompt = ' '
    },
  })
end

return Plugin


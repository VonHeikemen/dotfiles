-- NOTE: mini.notify should to extend vim.notify()
-- before other plugins are loaded.

local Plugin = {'nvim-mini/mini.notify'}

Plugin.opts = {
  lsp_progress = {
    enable = false,
  },
}

function Plugin.config(opts)
  require('mini.notify').setup(opts)

  vim.keymap.set('n', '<leader><space>', '<cmd>Notify clear<cr>')

  vim.api.nvim_create_user_command('Notify', function(input)
    local cmd = input.args
    if cmd == 'clear' then
      vim.cmd('echo ""')
      require('mini.notify').clear()
      return
    end

    if cmd == 'history' then
      require('mini.notify').show_history()
      return
    end
  end, {nargs = 1})
end

return Plugin


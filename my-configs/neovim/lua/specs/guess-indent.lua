-- Guess indentantion of current file
local Plugin = {'NMAC427/guess-indent.nvim'}

Plugin.cmd = {'AutoIndent', 'GuessIndent'}

function Plugin.config()
  require('guess-indent').setup({
    auto_cmd = false,
    verbose = 1
  })

  local autoindent = function()
    local bufnr = vim.fn.bufnr()
    vim.cmd('bufdo GuessIndent silent')
    vim.cmd({cmd = 'buffer', args = {bufnr}})
  end

  vim.api.nvim_create_user_command(
    'AutoIndent',
    function() vim.defer_fn(autoindent, 3) end,
    {desc = 'Guess indentantion in all files'}
  )
end

return Plugin


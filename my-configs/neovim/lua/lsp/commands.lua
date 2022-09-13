local command = vim.api.nvim_create_user_command

command('LoadLsp', function() require('lsp') end, {desc = 'Load lsp module'})

command('LspStart', function(input)
  require('lsp').start(input.args)
end, {
  nargs = 1,
  desc = 'Start LSP server',
  complete = function(arg)
    local f = vim.fn
    local configs = f.stdpath('config') .. '/lua/lsp/servers/*'
    local paths = vim.tbl_map(
      function(v) return f.fnamemodify(v, ':t:r') end,
      vim.split(f.glob(configs), '\n')
    )

    paths = vim.tbl_filter(function(s)
      return vim.startswith(s, arg)
    end, paths)

    return paths
  end
})


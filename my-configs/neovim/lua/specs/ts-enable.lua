local Plugin = {'VonHeikemen/ts-enable.nvim'}

Plugin.rev = 'v2.x'

Plugin.opts = {
  auto_install = false,
  highlights = true,
  regex_syntax = false,
  parser_settings = {
    php = {
      highlights = true,
      regex_syntax = true
    },
  }
}

function Plugin.install(event)
  local exec = 'TSEnableEnsureInstalled'
  if vim.v.vim_did_enter == 1 then
    vim.cmd(exec)
    return
  end

  vim.api.nvim_create_autocmd('VimEnter', {once = true, command = exec})
end

function Plugin.config(opts)
  vim.g.ts_enable = opts
end

return Plugin


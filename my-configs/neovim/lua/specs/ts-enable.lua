local Plugin = {'VonHeikemen/ts-enable.nvim'}

Plugin.rev = 'v2.x'

Plugin.opts = {
  auto_install = true,
  highlights = true,
  folds = false,
}

function Plugin.config(opts)
  vim.g.ts_enable = opts
end

return Plugin


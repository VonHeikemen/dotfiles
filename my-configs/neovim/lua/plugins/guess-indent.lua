local Plugin = {'NMAC427/guess-indent.nvim'}

Plugin.name = 'guess-indent'
Plugin.lazy = true

Plugin.cmd = 'GuessIndent'

Plugin.opts = {
  auto_cmd = false,
  verbose = 1
}

return Plugin


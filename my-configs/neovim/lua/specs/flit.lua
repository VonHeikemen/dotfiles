-- Enhanced f/t moves
local Plugin = {'ggandor/flit.nvim'}

Plugin.lazy = false

Plugin.dependencies = {
  {'ggandor/leap.nvim'},
}

Plugin.opts = {
  multiline = false,
}

return Plugin


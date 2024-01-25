-- Enhanced f/t moves
local Plugin = {'ggandor/flit.nvim'}

Plugin.name = 'flit'

Plugin.opts = {
  multiline = false,
}

Plugin.keys = {
  {'f', mode = {'n', 'x', 'o'}},
  {'F', mode = {'n', 'x', 'o'}},
  {'t', mode = {'n', 'x', 'o'}},
  {'T', mode = {'n', 'x', 'o'}},
}

return Plugin


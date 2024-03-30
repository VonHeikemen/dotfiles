---
-- Plugin is disabled for now, because I disabled leap.nvim
---

-- Enhanced f/t moves
local Plugin = {'ggandor/flit.nvim'}

Plugin.enabled = false

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


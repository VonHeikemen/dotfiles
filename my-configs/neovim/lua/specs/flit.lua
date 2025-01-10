-- Enhanced f/t moves
local Plugin = {'ggandor/flit.nvim'}
Plugin.depends = {'ggandor/leap.nvim'}

Plugin.user_event = {'SpecVimEdit'}

function Plugin.config()
  require('flit').setup({multiline = false})
end

return Plugin


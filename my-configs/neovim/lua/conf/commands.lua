local bridge = require 'bridge'
local fns = require 'conf.functions'
local lazy_loading = require 'conf.lazy_loading'

bridge.register_augroups {'user_cmds', 'quickfix_cmds'}
bridge.create_excmd('GetSelection', fns.get_selection)

local load_event = 'VimEnter'
if vim.fn.argc() == 0 then
  load_event = 'CmdlineEnter'
end

fns.autocmd({load_event, once = true}, lazy_loading)

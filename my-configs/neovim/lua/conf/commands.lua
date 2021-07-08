local fns = require 'conf.functions'
local bridge = require 'bridge'

bridge.register_augroups {'user_cmds', 'quickfix_cmds'}
bridge.create_excmd('GetSelection', fns.get_selection)


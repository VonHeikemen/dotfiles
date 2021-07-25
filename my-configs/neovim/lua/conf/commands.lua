local bridge = require 'bridge'
local fns = require 'conf.functions'

bridge.register_augroups {'user_cmds'}

bridge.create_excmd('GetSelection', fns.get_selection)
bridge.create_excmd('UseFZF', fns.use_fzf)

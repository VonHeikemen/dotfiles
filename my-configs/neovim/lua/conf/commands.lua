local bridge = require 'bridge'
local fns = require 'conf.functions'

bridge.create_excmd('GetSelection', fns.get_selection)
bridge.create_excmd('UseFZF', fns.use_fzf)

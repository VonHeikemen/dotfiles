local bridge = require 'bridge'
local fns = require 'conf.functions'
local getpaq = require 'plug'.paq_download

bridge.register_augroups {'user_cmds', 'quickfix_cmds'}
bridge.create_excmd('GetSelection', fns.get_selection)
bridge.create_excmd('PaqDownload', getpaq)


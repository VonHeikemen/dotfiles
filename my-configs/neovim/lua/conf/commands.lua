local bridge = require 'bridge'
local fns = require 'conf.functions'
local getpaq = require 'plug'.paq_download

bridge.create_excmd('GetSelection', fns.get_selection)
bridge.create_excmd('PaqDownload', getpaq)
bridge.create_excmd('UseFZF', fns.use_fzf)

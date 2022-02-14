local bridge = require('bridge')
local fns = require('conf.functions')

bridge.create_excmd('GetSelection', fns.get_selection)
bridge.create_excmd('TrailspaceTrim', fns.trailspace_trim)
bridge.create_excmd('SmartBufferPicker', fns.smart_buffer_picker)
bridge.create_excmd('EditMacro', fns.edit_macro)

vim.cmd('command! -nargs=* -bang LspSetupServers lua require("lsp").setup_servers({root_dir = "<bang>" == "!", <f-args>})')


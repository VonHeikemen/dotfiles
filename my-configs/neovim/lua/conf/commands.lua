local command = require('bridge').create_excmd
local fns = require('conf.functions')

command('GetSelection', fns.get_selection)
command('TrailspaceTrim', fns.trailspace_trim)
command('SmartBufferPicker', fns.smart_buffer_picker)
command('EditMacro', fns.edit_macro)


local bridge = require('bridge')
local fns = require('conf.functions')

bridge.create_excmd('GetSelection', fns.get_selection)
bridge.create_excmd('TrailspaceTrim', fns.trailspace_trim)
bridge.create_excmd('SmartBufferPicker', fns.smart_buffer_picker)
bridge.create_excmd('EditMacro', fns.edit_macro)


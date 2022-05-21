local fns = require('user.functions')
local command = vim.api.nvim_create_user_command

command('GetSelection', fns.get_selection, {})
command('TrailspaceTrim', fns.trailspace_trim, {})
command('SmartBufferPicker', fns.smart_buffer_picker, {})
command('EditMacro', fns.edit_macro, {})
command('LoadProject', fns.load_project, {})


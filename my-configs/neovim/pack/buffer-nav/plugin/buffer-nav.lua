local command = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('buffernav_cmds', {clear = true})

command('BufferNavMenu', function()
  require('buffer-nav').show_menu()
end, {})

command('BufferNav', function(input)
  local index = tonumber(input.args)
  if index == nil then
    return
  end

  require('buffer-nav').go_to_file(index)
end, {nargs = 1})


command('BufferNavMark', function(input)
  require('buffer-nav').add_file({show_buffers = input.bang})
end, {bang = true})

command('BufferNavRead', function(input)
  local path = input.args
  if path == nil then
    return
  end

  require('buffer-nav').load_content(path)
end, {nargs = 1, complete = 'file'})

command('BufferNavSave', function(input)
  require('buffer-nav').save_content(input.args)
end, {nargs = '?', complete = 'file'})

autocmd('FileType', {
  pattern = 'BufferNav',
  group = augroup,
  callback = function(event)
    require('buffer-nav').after_mount(event)
  end,
})


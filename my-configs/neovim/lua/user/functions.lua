local M = {}

function M.toggle_opt(prop, scope, on, off)
  if on == nil then
    on = true
  end

  if off == nil then
    off = false
  end

  if scope == nil then
    scope = 'o'
  end

  return function()
    if vim[scope][prop] == on then
      vim[scope][prop] = off
    else
      vim[scope][prop] = on
    end
  end
end

function M.job_output(cid, data, name)
  for i, val in pairs(data) do
    print(val)
  end
end

function M.file_explorer(cwd)
  local env = require('user.env')

  if vim.o.lines > env.small_screen_lines then
    require('lir.float').toggle(cwd)
  else
    vim.cmd({cmd = 'edit', args = {cwd or vim.fn.expand('%:p:h')}})
  end
end

return M


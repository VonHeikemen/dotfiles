local M = {}

function M.defaults()
  return {
    direction = 'bottom',
    size = 0.25,
    on_open = function(_) return 1 end
  }
end

function M.set(opts)
  M.current = vim.tbl_deep_extend('force', M.current, opts)
end

M.current = M.defaults()

return M


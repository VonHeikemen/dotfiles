local M = {}

function M.forward(opts)
  local args = {
    opts = {
      labels = '',
      safe_labels = '',
      case_sensitive = false,
    },
    inputlen = 1,
    inclusive = true,
    pattern = function(pt)
      return string.format('\\%%.l%s', pt)
    end,
  }

  if opts.offset then
    args.offset = -1 
  end

  require('leap').leap(args)
end

function M.backward(opts)
  local args = {
    opts = {
      labels = '',
      safe_labels = '',
      case_sensitive = false,
    },
    inputlen = 1,
    inclusive = true,
    backward = true,
    pattern = function(pt)
      return string.format('\\%%.l%s', pt)
    end,
  }

  if opts.offset then
    args.offset = 1
  end

  require('leap').leap(args)
end

return M


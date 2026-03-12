local M = {}

function M.get_rank(cursor, line, col)
  local editor_grid_aspect_ratio = 0.3
  local cur_line = cursor[1]
  local cur_col = cursor[2]
  local abs = math.abs
  local pow = math.pow

  -- get distance between cursor and match
  -- (based on leap.nvim's algorithm)
  local dx = (abs((col - cur_col)) * editor_grid_aspect_ratio)
  local dy = abs((line - cur_line))
  local diff = pow(((dx * dx) + (dy * dy)), 0.5)

  if line == cur_line then
    diff = diff - 99
    if col >= cur_col then
      diff = diff - 99
    else
      diff = diff - 30
    end
  end

  return diff
end

function M.join_pattern(str, pattern, max_column, targets)
  local res = M.find_pattern(str, pattern, max_column)

  if res[1] == nil then
    return
  end

  for _, ns in ipairs(res) do
    targets[#targets + 1] = ns
  end
end

function M.find_pattern(str, pattern, max_column)
  local match = true
  local last = 1
  local res = {}

  while match do
    local index, ends = string.find(str, pattern, last)
    match = type(index) == 'number'

    if match then
      local match_index = ends or index

      if max_column == -1 or match_index < max_column then
        res[#res + 1] = match_index
        last = match_index + 1
      else
        match = false
      end

    end
  end

  if res[1] then
    return res
  end

  return {}
end

return M


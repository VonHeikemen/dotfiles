local M = {}
local s = {}

function M.forward()
  local winid = vim.api.nvim_get_current_win()
  local get_targets = M.line_targets

  local comp = function(state, wininfo, line)
    if state.lnum == -1 then
      state.lnum = line
    end

    return state.lnum <= wininfo.botline
  end

  require('leap').leap({
    target_windows = {winid},
    targets = function()
      return get_targets(winid, comp)
    end
  })
end

function M.backward()
  local winid = vim.api.nvim_get_current_win()
  local get_targets = M.line_targets

  local comp = function(state, wininfo, line)
    if state.lnum == -1 then
      state.lnum = wininfo.topline
    end

    return state.lnum <= line
  end

  require('leap').leap({
    target_windows = {winid},
    targets = function()
      return get_targets(winid, comp)
    end
  })
end

function M.line_targets(winid, comp)
  local wininfo =  vim.fn.getwininfo(winid)[1]
  local cur_line = vim.fn.line('.')

  -- Get targets.
  local targets = {}
  local state = {lnum = -1}

  while comp(state, wininfo, cur_line) do
    -- Skip folded ranges.
    local fold_end = vim.fn.foldclosedend(state.lnum)
    if fold_end ~= -1 then
      state.lnum = fold_end + 1
    else
      if state.lnum ~= cur_line then
        table.insert(targets, { pos = { state.lnum, 1 } })
      end
      state.lnum = state.lnum + 1
    end
  end

  if #targets == 0 then
    return
  end

  -- Sort them by vertical screen distance from cursor.
  local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)['row']

  local screen_rows_from_cursor = function(t)
    local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])['row']
    return math.abs(cur_screen_row - t_screen_row)
  end

  table.sort(targets, function(t1, t2)
    return screen_rows_from_cursor(t1) < screen_rows_from_cursor(t2)
  end)

  return targets
end

return M


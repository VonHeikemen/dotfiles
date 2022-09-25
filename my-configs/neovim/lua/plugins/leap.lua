local M = {}
local bind = vim.keymap.set

require('leap').setup({
  safe_labels = {},
  labels = {
    'w', 's', 'a',
    'j', 'k', 'l', 'o', 'i', 'q', 'd', 'h', 'g',
    'u', 't',
    'm', 'v', 'c', 'n', '.', 'z',
    '/', 'D', 'L', 'N', 'H', 'G', 'M', 'U', 'T', '?', 'Z',
    'J', 'K', 'O', 'I'
  },
})

local function leap_line_backward()
  local winid = vim.api.nvim_get_current_win()
  local comp = function(state, wininfo, line)
    if state.lnum == -1 then
      state.lnum = wininfo.topline
    end

    return state.lnum <= line
  end

  require('leap').leap({
    targets = M.line_targets(winid, comp),
    target_windows = {winid}
  })
end

local function leap_line_forward()
  local winid = vim.api.nvim_get_current_win()
  local comp = function(state, wininfo, line)
    if state.lnum == -1 then
      state.lnum = line
    end

    return state.lnum <= wininfo.botline
  end

  require('leap').leap({
    targets = M.line_targets(winid, comp),
    target_windows = {winid}
  })
end

bind({'n', 'x', 'o'}, 'e', '<Plug>(leap-forward)')
bind({'n', 'x', 'o'}, 'b', '<Plug>(leap-backward)')

bind({'n', 'x', 'o'}, 'e', leap_line_forward, {desc = 'Jump to line below cursor'})
bind({'n', 'x', 'o'}, 'B', leap_line_backward, {desc = 'Jump to line above cursor'})

bind({'n', 'x', 'o'}, 'H', 'b')
bind({'n', 'x', 'o'}, 'L', 'e')

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


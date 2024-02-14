-- Jump anywhere
local Plugin = {'ggandor/leap.nvim'}
local user = {}

Plugin.opts = {
  safe_labels = {},
  labels = {
    'w', 's', 'a',
    'j', 'k', 'l', 'o', 'i', 'q', 'd', 'h', 'g',
    'u', 'y',
    'm', 'v', 'c', 'n', '.', 'x',
    'Q', 'D', 'L', 'N', 'H', 'G', 'M', 'U', 'Y', 'X',
    'J', 'K', 'O', 'I', 'A', 'S', 'W'
  },
}

function Plugin.init()
  vim.keymap.set({'n', 'x', 'o'}, 'gH', 'H')
  vim.keymap.set({'n', 'x', 'o'}, 'gL', 'L')
end

function Plugin.keys()
  local keys = {}
  local mode = {'n', 'x', 'o'} 
  local bind = function(l, r, d)
    table.insert(keys, {l, r, desc = d, mode = mode})
  end

  bind('su', '<Plug>(leap-backward-to)')
  bind('sj', '<Plug>(leap-forward-to)')

  bind('H', user.line_backward, 'Jump to line above cursor')
  bind('L', user.line_forward, 'Jump to line below cursor')

  bind('ge', function() user.jump_to_word(true) end, 'Jump to word')

  return keys
end

function user.line_backward()
  local winid = vim.api.nvim_get_current_win()
  local comp = function(state, wininfo, line)
    if state.lnum == -1 then
      state.lnum = wininfo.topline
    end

    return state.lnum <= line
  end

  require('leap').leap({
    targets = user.line_targets(winid, comp),
    target_windows = {winid}
  })
end

function user.line_forward()
  local winid = vim.api.nvim_get_current_win()
  local comp = function(state, wininfo, line)
    if state.lnum == -1 then
      state.lnum = line
    end

    return state.lnum <= wininfo.botline
  end

  require('leap').leap({
    targets = user.line_targets(winid, comp),
    target_windows = {winid}
  })
end

function user.line_targets(winid, comp)
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

function user.jump_to_word(ignore_underscore)
  local search = require('leap.search')
  local modify_keyword = false

  local ch = vim.fn.getcharstr()

  if ch == ' ' then
    print('Must insert a non-whitespace character')
    return
  end

  local pattern = string.format('\\V%s', ch)

  if ch:match('[a-z0-9]') then
    pattern = string.format('\\<%s', ch)
    modify_keyword = ignore_underscore
  elseif ch:match('[A-Z]') then
    local regex = [[\<%s\|\<%s\|[a-z]\@<=%s]]
    pattern = regex:format(ch:lower(), ch, ch)
    modify_keyword = ignore_underscore
  end

  if modify_keyword then
    vim.opt.iskeyword:remove('_')
  end

  local winid = vim.api.nvim_get_current_win()
  local targets = search['get-targets'](pattern, {['target-windows'] = {winid}})

  if modify_keyword then
    vim.opt.iskeyword:append('_')
  end

  if targets == nil then
    print('No targets found')
    return
  end

  require('leap').leap({targets = targets})
end

return Plugin


local M = {}

local core = require('leap-ext.core')
local esc_key = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

function M.start()
  local winid = vim.api.nvim_get_current_win()
  require('leap').leap({
    target_windows = {winid},
    targets = M.get_targets
  })
end

function M.get_targets()
  local prompt = ' '
  local pos = vim.fn.getpos('.')
  local cursor_pos = {pos[2], pos[3]}

  local max_column = vim.o.columns

  vim.api.nvim_echo({{prompt}}, false, {})
  local ok, ch = pcall(vim.fn.getcharstr)

  if ok == false or ch == nil or ch == esc_key then
    return
  end

  local char_pattern = ''
  local camel_pattern = '[%l]'
  local word_start = '[%s%p]+'

  if ch:match('[a-z]') then
    local upper = ch:upper()
    char_pattern = string.format('[%s%s]', ch, upper)
    camel_pattern = camel_pattern .. upper
    word_start = word_start .. char_pattern
  elseif ch:match('[A-Z]') then
    char_pattern = ch
    camel_pattern = camel_pattern .. ch
    word_start = word_start .. char_pattern
  else
    char_pattern = vim.pesc(ch)
    camel_pattern = false
    word_start = false
  end

  local get_fold_end = vim.fn.foldclosedend
  local get_line = vim.fn.getline
  local rank = core.get_rank

  local targets = {}
  local line = vim.fn.line('w0')
  local last_line = vim.fn.line('w$')

  while line <= last_line do
    local step = {}

    -- exclude folded lines
    local fold_end = get_fold_end(line)
    if fold_end > 0 then
      line = fold_end + 1
    end

    local str = get_line(line)

    if word_start then
      local first_match = str:sub(1, 1):find(char_pattern)

      if first_match then
        step = {first_match}
      end

      core.join_pattern(str, word_start, max_column, step)
    else
      step = core.find_pattern(str, char_pattern, max_column)
    end

    if camel_pattern then
      core.join_pattern(str, camel_pattern, max_column, step)
    end

    -- transform result to "target format"
    if step[1] then
      for _, match in ipairs(step) do
        local same = match == cursor_pos[2] and line == cursor_pos[1]
        if not same then
          targets[#targets + 1] = {
            pos = {line, match},
            rank = rank(cursor_pos, line, match),
          }
        end
      end
    end

    line = line + 1
  end

  if targets[1] then
    table.sort(targets, function(a, b)
      return a.rank < b.rank
    end)
  end

  return targets
end

return M


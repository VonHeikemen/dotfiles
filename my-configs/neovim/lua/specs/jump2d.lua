-- Jump anywhere
local Plugin = {'echasnovski/mini.jump2d'}
local user = {}

Plugin.branch = 'stable'

Plugin.main = 'mini.jump2d'

Plugin.opts = {
  allowed_lines = {
    blank = false,
    fold = false,
  },
  allowed_windows = {
    not_current = false
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

  bind('r', user.jump_word(), 'Jump to word')
  bind('R', user.jump_char(), 'Jump to character')

  bind('H', user.jump_line('up'), 'Jump to line above cursor')
  bind('L', user.jump_line('down'), 'Jump to line below cursor')

  return keys
end

function user.jump_line(dir)
  local jump = require('mini.jump2d')

  local opts = vim.deepcopy(jump.builtin_opts.line_start)

  opts.labels = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKL'

  opts.allowed_lines = {
    blank = true,
    cursor_at = false,
    cursor_before = true,
    cursor_after = false,
  }

  if dir == 'down' then
    opts.allowed_lines.cursor_before = false
    opts.allowed_lines.cursor_after = true
  end

  return function()
    jump.start(opts)
  end
end

function user.jump_char()
  local jump = require('mini.jump2d')
  local opts = jump.builtin_opts.single_character
  return function()
    jump.start(opts)
  end
end

function user.jump_word()
  local jump = require('mini.jump2d')

  local opts = {hooks = {}}
  local noop = function() return {} end
  local word_start = jump.builtin_opts.word_start.spotter

  opts.spotter = noop

  opts.hooks.before_start = function()
    local ok, ch = pcall(vim.fn.getcharstr)
    if ok == false or ch == nil then
      opts.spotter = noop
      return
    end

    local char
    local skip_word_filter = true
    if ch:match('[a-z]') then
      local pattern = string.format('[%s%s]', ch, ch:upper())
      char = jump.gen_pattern_spotter(pattern)
      skip_word_filter = false
    elseif ch:match('[A-Z]') then
      char = jump.gen_pattern_spotter(ch)
    else
      local pattern = string.format('[%s]', vim.pesc(ch))
      char = jump.gen_pattern_spotter(pattern)
    end

    opts.spotter = function(num, args)
      local cs = char(num, args)

      if cs == nil then
        return {}
      end

      if skip_word_filter then
        return cs
      end

      local ws = word_start(num, args)
      local res = {}

      for _, i in ipairs(cs) do
        if vim.tbl_contains(ws, i) then
          res[#res + 1] = i
        end
      end

      return res
    end
  end

  return function()
    jump.start(opts)
  end
end

return Plugin


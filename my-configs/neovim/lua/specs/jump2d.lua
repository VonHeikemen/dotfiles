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
  mappings = {
    start_jumping = '',
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
  bind('<leader>j', user.jump_char(), '2-character search')

  bind('H', user.jump_line('up'), 'Jump to line above cursor')
  bind('L', user.jump_line('down'), 'Jump to line below cursor')

  return keys
end

function user.noop()
  return {}
end

function user.jump_line(dir)
  local opts = {hooks = {}}

  opts.labels = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKL'

  opts.allowed_lines = {
    blank = true,
    cursor_at = false,
    cursor_before = true,
    cursor_after = false,
  }

  opts.hooks.before_start = function()
    local ls = require('mini.jump2d').builtin_opts.line_start

    opts.spotter = ls.spotter
    opts.hooks.after_jump = ls.hooks.after_jump
    opts.hooks.before_start = nil
  end

  if dir == 'down' then
    opts.allowed_lines.cursor_before = false
    opts.allowed_lines.cursor_after = true
  end

  return function()
    require('mini.jump2d').start(opts)
  end
end

function user.jump_char()
  local opts = {hooks = {}}
  local noop = user.noop
  local fmt = string.format
  local esc = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)

  opts.hooks.before_start = function()
    local input = ''
    local prompt = '> '
    local max_chars = 2

    vim.api.nvim_echo({{prompt}}, false, {})
    for _=1, max_chars, 1 do
      local ok, ch = pcall(vim.fn.getcharstr)
      if ok == false or ch == nil or ch == esc then
        opts.spotter = noop
        return
      end

      prompt = fmt('%s%s', prompt, ch)
      vim.api.nvim_echo({{prompt}}, false, {})

      if ch:match('[a-zA-Z]') then
        input = fmt('%s[%s%s]', input, ch:lower(), ch:upper())
      else
        input = fmt('%s%s', input, vim.pesc(ch))
      end
    end

    opts.spotter = require('mini.jump2d').gen_pattern_spotter(input)
  end

  opts.hooks.after_jump = function()
    vim.cmd("echo '' | redraw")
  end

  return function()
    require('mini.jump2d').start(opts)
  end
end

function user.jump_word()
  local opts = {hooks = {}}
  local noop = user.noop

  opts.spotter = noop

  local gen_word_start = function(char_pattern, char)
    local jump = require('mini.jump2d')

    local camel_pattern = string.format('[%%l]+%s', char)
    local camel_spotter = jump.gen_pattern_spotter(camel_pattern, 'end')

    local word_spotter = jump.builtin_opts.word_start.spotter
    local char_spotter = jump.gen_pattern_spotter(char_pattern)

    local word_start = function(num, args)
      local cs = char_spotter(num, args)
      if cs == nil then
        return {}
      end

      local ws = word_spotter(num, args)
      local res = {}

      for _, i in ipairs(cs) do
        if vim.tbl_contains(ws, i) then
          res[#res + 1] = i
        end
      end

      return res
    end

    return jump.gen_union_spotter(word_start, camel_spotter)
  end

  opts.hooks.before_start = function()
    local ok, ch = pcall(vim.fn.getcharstr)
    if ok == false or ch == nil then
      opts.spotter = noop
      return
    end

    if ch:match('[a-z]') then
      local upper = ch:upper()
      local pattern = string.format('[%s%s]', ch, upper)

      opts.spotter = gen_word_start(pattern, upper)
      return
    end

    if ch:match('[A-Z]') then
      opts.spotter = gen_word_start(ch, ch)
      return
    end

    local pattern = string.format('[%s]', vim.pesc(ch))
    opts.spotter = require('mini.jump2d').gen_pattern_spotter(pattern)
  end

  return function()
    require('mini.jump2d').start(opts)
  end
end

return Plugin


-- Jump anywhere
local Plugin = {'ggandor/leap.nvim'}
local user = {}

Plugin.lazy = false

Plugin.opts = {
  safe_labels = '',
  labels = {
    'w', 's', 'a',
    'j', 'k', 'l', 'o', 'i', 'q', 'd', 'h', 'g',
    'u', 'y',
    'm', 'v', 'c', 'n', '.', 'x',
    'Q', 'D', 'L', 'N', 'H', 'G', 'M', 'U', 'Y', 'X',
    'J', 'K', 'O', 'I', 'A', 'S', 'W',
    '1', '2', '3', '4', '5', '6'
  },
}

function Plugin.init()
  local mode = {'n', 'x', 'o'} 
  local bind = function(l, r, d)
    vim.keymap.set(mode, l, r, {desc = d})
  end

  bind('gH', 'H')
  bind('gL', 'L')

  bind('r', function()
    require('leap-ext.word').start()
  end, 'Jump to word')

  bind('H',function()
    require('leap-ext.line').backward()
  end, 'Jump to line above cursor')

  bind('L',function()
    require('leap-ext.line').forward()
  end, 'Jump to line below cursor')

  bind('<leader>j', '<Plug>(leap)', '2-character search')
end

return Plugin


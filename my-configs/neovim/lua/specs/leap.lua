-- Jump anywhere
local Plugin = {'https://codeberg.org/andyg/leap.nvim'}

Plugin.user_event = {'SpecVimEdit'}

function Plugin.opts()
  local env = vim.g.env or {}
  local opts = {
    safe_labels = '',
    labels = table.concat({
      'w', 's', 'a',
      'j', 'k', 'l', 'o', 'i', 'q', 'd', 'h', 'g',
      'u', 'y',
      'm', 'v', 'c', 'n', '.', 'x',
      'Q', 'D', 'L', 'N', 'H', 'G', 'M', 'U', 'Y', 'X',
      'J', 'K', 'O', 'I', 'A', 'S', 'W',
      '1', '2', '3', '4', '5', '6'
    }, ''),
  }

  if env.latam_qwerty then
    opts.keys = {
      next_target = 'ñ',
      prev_target = 'Ñ',
      next_group = '<Tab>',
      prev_group = '<S-Tab>',
    }
  end

  return opts
end

function Plugin.init()
  local mode = {'n', 'x', 'o'} 
  local bind = function(l, r, d)
    vim.keymap.set(mode, l, r, {desc = d})
  end

  bind('gW', 'gw')

  -- note: leap-ext is a module from pack/plugins/start/leap-ext
  bind('gw', function()
    require('leap-ext.word').start()
  end, 'Jump to word')

  bind('sH',function()
    require('leap-ext.line').backward()
  end, 'Jump to line above cursor')

  bind('sL',function()
    require('leap-ext.line').forward()
  end, 'Jump to line below cursor')

  bind('f', function()
    require('leap-ext.char').forward({offset = false})
  end, 'Case insensitive f')

  bind('t', function()
    require('leap-ext.char').forward({offset = true})
  end, 'Case insensitive t')

  bind('F', function()
    require('leap-ext.char').backward({offset = false})
  end, 'Case insensitive F')

  bind('T', function()
    require('leap-ext.char').backward({offset = true})
  end, 'Case insensitive T')

  bind('sh', '<Plug>(leap-backward)', 'Jump backward')
  bind('sl', '<Plug>(leap-forward)', 'Jump forward')
end

function Plugin.config(opts)
  require('leap').setup(opts())
end

return Plugin


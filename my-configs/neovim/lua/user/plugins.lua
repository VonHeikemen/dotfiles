local env = require('user.env')
local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
    print('Done.')
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {
  ui = {
    icons = env.lazy_icons,
    border = 'rounded',
  },
  install = {
    colorscheme = {'nightly'}
  },
  change_detection = {
    enabled = true, -- check for config file changes
    notify = true, -- get a notification when changes are found
  },
}

lazy.setup({{import = 'plugins'}})

-- ========================================================================== --
-- ==                            LOCAL PLUGINS                             == --
-- ========================================================================== --

require('plugins.core.tmux')
require('plugins.core.session')
require('plugins.core.tabline').setup()
require('plugins.core.statusline').setup()


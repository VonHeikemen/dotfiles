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
    missing = true,            -- install missing plugins on startup.
    colorscheme = {'nightly'}  -- use this theme during first install process
  },
  change_detection = {
    enabled = true, -- check for config file changes
    notify = true,  -- get a notification when changes are found
  },
}

lazy.setup({
  -- Load them from the lua/specs folder
  {import = 'specs'}
})

local augroup = vim.api.nvim_create_augroup('lazy_cmds', {clear = true})
local snapshot_dir = vim.fn.stdpath('data') .. '/plugin-snapshot'
local lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json'

vim.api.nvim_create_user_command('LazySnapshot', function()
  vim.cmd.edit(snapshot_dir)
  vim.cmd.vsplit(lockfile)
end, {})

vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'LazyUpdatePre',
  desc = 'Backup lazy.nvim lockfile',
  callback = function()
    vim.fn.mkdir(snapshot_dir, 'p')
    local snapshot = snapshot_dir .. os.date('/%Y-%m-%dT%H:%M:%S.json')

    vim.loop.fs_copyfile(lockfile, snapshot)
  end,
})


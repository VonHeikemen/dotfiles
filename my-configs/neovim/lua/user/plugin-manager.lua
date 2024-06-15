local join = vim.fs.joinpath
local snapshot_dir = join(vim.fn.stdpath('data'), 'plugin-snapshot')
local env = require('user.env')
ocal lazy = {}

unction lazy.install(path)
 if not vim.uv.fs_stat(path) then
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

    -- create folder for backup lockfiles
    vim.fn.mkdir(snapshot_dir, 'p')
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = join(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
lazy.opts = {
  ui = {
    icons = env.lazy_icons,
    border = 'rounded',
  },
  install = {
    missing = true,            -- install missing plugins on startup.
    colorscheme = {'habamax'}  -- use this theme during first install process
  },
  change_detection = {
    enabled = true, -- check for config file changes
    notify = true,  -- get a notification when changes are found
  },
}

lazy.setup({
  -- Load plugin config from the lua/specs folder
  {import = 'specs'},

  -- Load config for local plugins from lua/specs/homemade
  {import = 'specs.homemade'},
})

local augroup = vim.api.nvim_create_augroup('lazy_cmds', {clear = true})
local lockfile = join(vim.fn.stdpath('config'), 'lazy-lock.json')

vim.api.nvim_create_user_command('LazySnapshot', function()
  vim.cmd.edit(snapshot_dir)
  vim.cmd.vsplit(lockfile)
end, {})

vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'LazyUpdatePre',
  desc = 'Backup lazy.nvim lockfile',
  callback = function()
    local snapshot = join(snapshot_dir, os.date('%Y-%m-%dT%H:%M:%S.json'))
    vim.uv.fs_copyfile(lockfile, snapshot)
  end,
})


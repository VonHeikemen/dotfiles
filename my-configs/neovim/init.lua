-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep  - https://github.com/BurntSushi/ripgrep

-- Try to load "env" file
local ok, env = pcall(require, 'conf.env')

if not ok then
  vim.notify(
    'lua/conf/env.lua not found. You should probably rename env.sample',
    vim.log.levels.ERROR
  )
  return
end

-- tweak colorscheme
if env.theme_tweaks then
  vim.cmd('source ' .. env.theme_tweaks)
end

-- Basic editor options
require('conf.basic')

-- User defined commands
require('conf.commands')

-- Install plugins if necessary
if require('plugins.install') then return end

-- Plugin management and config
require('conf.plugins')

-- Keybindings
require('conf.keymaps')


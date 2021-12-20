-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep  - https://github.com/BurntSushi/ripgrep
-- minpac   - https://github.com/k-takata/minpac

-- Try to load "env" file
local ok, env = pcall(require, 'conf.env')

if not ok then
  vim.cmd('echoerr "lua/conf/env.lua not found. You should probably rename env.sample"')
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

-- Keybindings
require('conf.keymaps')

-- Plugin management and config
require('conf.plugins')

-- Install plugins if necessary
require('conf.plugins.install')


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

-- Install plugins if necessary
require('conf.plugins.install')

-- Basic editor options
require('conf.basic')

-- User defined commands
require('conf.commands')

-- Plugin management and config
require('conf.plugins')

-- Keybindings
require('conf.keymaps')


-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep    - https://github.com/BurntSushi/ripgrep
-- fd         - https://github.com/sharkdp/fd
-- git        - https://git-scm.com/
-- make       - https://www.gnu.org/software/make/
-- c compiler - gcc or tcc or zig

-- Try to load "env" file
local ok, env = pcall(require, 'user.env')

if not ok then
  local msg = 'lua/user/env.lua not found. You should probably rename env.sample',
  vim.notify(msg, vim.log.levels.ERROR)
  return
end

-- Basic editor options
require('user.settings')

-- User defined commands
require('user.commands')

-- Install plugins if necessary
if require('plugins.install') then return end

-- Keybindings
require('user.keymaps')

-- Plugin management and config
require('user.plugins')


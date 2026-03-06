-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep    - https://github.com/BurntSushi/ripgrep
-- fd         - https://github.com/sharkdp/fd
-- git        - https://git-scm.com/
-- tig        - https://jonas.github.io/tig/
-- c compiler - gcc or tcc or zig

-- NOTE:
-- To complete installation you should
-- rename lua/user/env.sample to lua/user/env.lua

-- use neovim's lua module loader
-- see :help vim.loader.enable()
vim.loader.enable()

pcall(require, 'user.env')

require('user.settings')
require('user.commands')
require('user.keymaps')
require('user.pack')

vim.cmd('colorscheme sigil')
require('user.statusline')
require('user.tabline')


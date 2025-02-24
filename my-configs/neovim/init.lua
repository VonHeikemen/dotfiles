-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep    - https://github.com/BurntSushi/ripgrep
-- fd         - https://github.com/sharkdp/fd
-- git        - https://git-scm.com/
-- tig        - https://jonas.github.io/tig/
-- c compiler - gcc or tcc or zig

-- use neovim's lua module loader (experimental)
-- see :help vim.loader.enable()
vim.loader.enable()

require('user.settings')
require('user.commands')
require('user.keymaps')
require('user.pack')

vim.cmd('colorscheme sigil')
require('user.statusline')
require('user.tabline')


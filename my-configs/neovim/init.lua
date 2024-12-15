-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep    - https://github.com/BurntSushi/ripgrep
-- fd         - https://github.com/sharkdp/fd
-- git        - https://git-scm.com/
-- tig        - https://jonas.github.io/tig/
-- c compiler - gcc or tcc or zig

require('user.settings')
require('user.commands')
require('user.keymaps')
require('user.plugin-manager')

-- Apply theme
vim.cmd('colorscheme sigil')


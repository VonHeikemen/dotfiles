-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- fzf      - https://github.com/junegunn/fzf
-- ripgrep  - https://github.com/BurntSushi/ripgrep
-- minpac   - https://github.com/k-takata/minpac

-- tweak colorscheme
local env = require 'conf.env'

if env.theme_tweaks then
  vim.cmd('source ' .. env.theme_tweaks)
end

-- Basic editor options
require 'conf.basic'

-- User defined commands
require 'conf.commands'

-- Plugin management and config
require 'conf.plugins'

-- You know
require 'conf.keymaps'


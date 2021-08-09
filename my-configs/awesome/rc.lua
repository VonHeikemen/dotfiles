-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- lain - https://github.com/lcpz/lain

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

-- Standard awesome library
local gears = require 'gears'
require 'awful.autofocus'

-- Theme handling library
local beautiful = require 'beautiful'

-- Prevent naughty from hijacking the system's notification daemon
package.loaded['naughty.dbus'] = {}

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require 'awful.hotkeys_popup.keys'

-- Variable definitions
require 'globals'

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() ..  'theme/theme.lua')

-- Statusbar things
require 'statusbar.setup'

-- Keybindings
local keymaps = require 'keymaps'
root.buttons(keymaps.mouse)
root.keys(keymaps.global)

-- Windows behavior
require 'rules'
require 'events'


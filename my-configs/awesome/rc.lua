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

-- Notification library
local naughty = require 'naughty'

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require 'awful.hotkeys_popup.keys'

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = 'Oops, there were errors during startup!',
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal('debug::error', function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
      in_error = true

      naughty.notify({
        preset = naughty.config.presets.critical,
        title = 'Oops, an error happened!',
        text = tostring(err)
      })

      in_error = false
  end)
end

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


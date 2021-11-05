local awful = require 'awful'
local menubar = require 'menubar'

os.setlocale(os.getenv('LANG'))

User = {
  terminal = 'x-terminal-emulator',
  editor = os.getenv('EDITOR') or 'nvim',
  modkey = 'Mod4'
}

User.editor_cmd = User.terminal .. ' -e ' .. User.editor

-- Menubar configuration
menubar.utils.terminal = User.terminal -- Set the terminal for applications that require it

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  -- awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
}


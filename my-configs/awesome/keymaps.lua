local awful = require 'awful'
local beautiful = require 'beautiful'
local join = require 'gears'.table.join
local hotkeys_popup = require 'awful.hotkeys_popup'
local menu  = require 'statusbar.widgets'.main_menu
local cyclefocus = require 'cyclefocus'
local lain = require 'lain'

local M = {}
local key = awful.key

local spawn = function(cmd)
  return function() awful.spawn(cmd) end
end

local term = function(cmd)
  return terminal .. ' -e ' .. cmd
end

local dropdown_terminal = lain.util.quake({
  app = terminal,
  argname = '--name %s',
  followtag = true,
  width = 0.8,
  height = 0.4,
  horiz = 'center',
  settings = function(c)
    awful.titlebar.hide(c)
  end
})

local alt_tab = function()
  cyclefocus.cycle({
    display_notifications = false,
    move_mouse_pointer = false,
    modifier = 'Alt_L',
    cycle_filters = {cyclefocus.filters.common_tag},
    keys = {'Tab', 'ISO_Left_Tab'}
  })
end

local move_mouse = function(x, y)
  local cmd = 'xdotool mousemove_relative --sync -- %s %s'
  return spawn(cmd:format(x, y))
end

local mod = modkey
local shift = 'Shift'
local ctrl = 'Control'
local alt = 'Mod1'

local App = {
  terminal = terminal,
  launcher = 'rofi -show drun',
  browser = 'x-www-browser',
  filemanager = 'pcmanfm',
  calculator = 'galculator',
  musicplayer = term 'tmux new-session -A -D -s music cmus',
}

M.global = join(
  -- Launch common applications
  key(
    {mod}, 'Return', spawn(App.terminal),
    {description = 'open a terminal', group = 'launcher'}
  ),
  key(
    {}, 'F1', function() dropdown_terminal:toggle() end,
    {description = 'toggle dropdown terminal', group = 'launcher'}
  ),
  key(
    {mod}, 'F2', spawn(App.browser),
    {description = 'open web browser', group = 'launcher'}
  ),
  key(
    {mod}, 'F3', spawn(App.filemanager),
    {description = 'open file manager', group = 'launcher'}
  ),
  key(
    {mod}, 'F4', spawn(App.calculator),
    {description = 'open calculator', group = 'launcher'}
  ),
  key(
    {mod}, 'F12', spawn(App.musicplayer),
    {description = 'open music player', group = 'launcher'}
  ),
  key(
    {mod}, 'p', spawn(term 'htop'),
    {description = 'inspect system resources', group = 'launcher'}
  ),
  key(
    {mod}, 'd', spawn(App.launcher),
    {description = 'open application launcher', group = 'launcher'}
  ),

  -- Manage awesome
  key(
    {mod, ctrl}, 'r', awesome.restart,
    {description = 'reload awesome', group = 'awesome'}
  ),
  key(
    {mod}, 'Escape', function() awesome.quit() end,
    {description = 'quit awesome', group = 'awesome'}
  ),
  key(
    {mod, shift}, 'Return', hotkeys_popup.show_help,
    {description='show help', group='awesome'}
  ),

  -- Focus windows
  key(
    {mod}, 'h', function() awful.client.focus.byidx(-1) end,
    {description = 'focus previous by index', group = 'client'}
  ),
  key(
    {mod}, 'l', function() awful.client.focus.byidx(1) end,
    {description = 'focus next by index', group = 'client'}
  ),
  key(
    {mod}, 'k', function() awful.client.focus.byidx(-1) end,
    {description = 'focus previous by index', group = 'client'}
  ),
  key(
    {mod}, 'j', function() awful.client.focus.byidx(1) end,
    {description = 'focus next by index', group = 'client'}
  ),
  key(
    {alt}, 'Tab', alt_tab,
    {description = 'change focus', group = 'client'}
  ),
  key(
    {alt, shift}, 'Tab', alt_tab,
    {description = 'change focus (opposite direction)', group = 'client'}
  ),

  -- Move windows
  key(
    {mod, shift}, 'j', function() awful.client.swap.byidx(1) end,
    {description = 'swap with next client by index', group = 'client'}
  ),
  key(
    {mod, shift}, 'k', function() awful.client.swap.byidx(-1) end,
    {description = 'swap with previous client by index', group = 'client'}
  ),

  -- Resize windows
  key(
    {mod}, 'bracketright', function() awful.tag.incmwfact(0.05) end,
    {description = 'increase master width factor', group = 'layout'}
  ),
  key(
    {mod}, 'bracketleft', function() awful.tag.incmwfact(1.05) end,
    {description = 'decrease master width factor', group = 'layout'}
  ),
  key(
    {mod, shift}, 'e',
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal('request::activate', 'key.unminimize', {raise = true})
      end
    end,
    {description = 'restore minimized', group = 'client'}
  ),

  -- Change layouts
  key(
    {mod}, 'grave', function() awful.layout.inc(1) end,
    {description = 'select next', group = 'layout'}
  ),
  key(
    {mod, shift}, 'F1', function() awful.layout.set(awful.layout.suit.floating) end,
    {description = 'select floating layout', group = 'layout'}
  ),
  key(
    {mod, shift}, 'F2', function() awful.layout.set(awful.layout.suit.max) end,
    {description = 'select max layout', group = 'layout'}
  ),
  key(
    {mod, shift}, 'F3', function() awful.layout.set(awful.layout.suit.tile) end,
    {description = 'select tile layout', group = 'layout'}
  ),
  key(
    {mod, shift}, 'F4', function() awful.layout.set(awful.layout.suit.tile.bottom) end,
    {description = 'select tile bottom layout', group = 'layout'}
  ),

  -- control cmus
  key(
    {}, 'F9', spawn('cmus-remote --pause'),
    {description = 'pause cmus', group = 'music'}
  ),
  key(
    {}, 'F10', spawn('cmus-remote --prev'),
    {description = 'previous song', group = 'music'}
  ),
  key(
    {}, 'F11', spawn('cmus-remote --next'),
    {description = 'next song', group = 'music'}
  ),
  key(
    {mod}, 'equal', spawn('amixer set Master 10%+'),
    {description = 'volume up', group = 'music'}
  ),
  key(
    {mod}, 'minus', spawn('amixer set Master 10%-'),
    {description = 'volume down', group = 'music'}
  ),

  -- Take screenshots
  key(
    {}, 'Print', spawn('gnome-screenshot -i'),
    {description = 'take screenshot', group = 'client'}
  ),

  -- Move mouse
  key(
    {mod}, 'KP_Left', move_mouse('-15', '0'),
    {description = 'move mouse to the left', group = 'mouse'}
  ),
  key(
    {mod}, 'KP_Right', move_mouse('15', '0'),
    {description = 'move mouse to the right', group = 'mouse'}
  ),
  key(
    {mod}, 'KP_Up', move_mouse('0', '-15'),
    {description = 'move mouse up', group = 'mouse'}
  ),
  key(
    {mod}, 'KP_Begin', move_mouse('0', '15'),
    {description = 'move mouse down', group = 'mouse'}
  ),
  key(
    {mod}, 'KP_Insert', spawn('xdotool click 1'),
    {description = 'left click', group = 'mouse'}
  ),
  key(
    {mod}, 'KP_End', spawn('xdotool click 3'),
    {description = 'right click', group = 'mouse'}
  ),
  key(
    {mod}, 'Page_Up', spawn('xdotool click 4'),
    {description = 'wheel up', group = 'mouse'}
  ),
  key(
    {mod}, 'Page_Down', spawn('xdotool click 5'),
    {description = 'wheel down', group = 'mouse'}
  ),
  key(
    {mod}, 'x', spawn('xdotool mousemove 0 1080'),
    {description = 'move mouse to a corner', group = 'mouse'}
  ),
  key(
    {mod, shift}, 'x', spawn('xdotool mousemove 960 540'),
    {description = 'move mouse to the center of the screen', group = 'mouse'}
  )
)

-- Bind all key numbers to tags.
for i = 1, 4 do
  M.global = join(M.global,
    -- View tag only.
    key(
      {mod}, '#' .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      {description = 'view tag #'..i, group = 'tag'}
    ),

    -- Toggle tag display.
    key(
      {mod, ctrl}, '#' .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      {description = 'toggle tag #' .. i, group = 'tag'}
    ),

    -- Move client to tag.
    key(
      {mod, shift}, '#' .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      {description = 'move focused client to tag #'..i, group = 'tag'}
    ),

    -- Toggle tag on focused client.
    key(
      {mod, ctrl, shift}, '#' .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      {description = 'toggle focused client on tag #' .. i, group = 'tag'}
    )
  )
end

M.client = join(
  key(
    {mod, shift}, 'q', function(c) c:kill() end,
    {description = 'close', group = 'client'}
  ),
  key(
    {alt}, 'F11',
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = 'toggle fullscreen', group = 'client'}
  ),
  key(
    {mod}, 'f',  awful.client.floating.toggle,
    {description = 'toggle floating', group = 'client'}
  ),
  key(
    {mod}, 'g', function(c) c:swap(awful.client.getmaster()) end,
    {description = 'move to master', group = 'client'}
  ),
  key(
    {mod}, 'e', function(c) c.minimized = true end,
    {description = 'minimize', group = 'client'}
  ),
  key(
    {mod}, 'c',
    function(c)
      awful.placement.align(c, {position = 'centered'})
    end,
    {description = 'center client on screen', group = 'client'}
  ),

  key(
    {mod}, 'm',
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    {description = '(un)maximize', group = 'client'}
  ),
  key(
    {mod, shift}, 'm',
    function(c)
      awful.titlebar.hide(c)
      c.maximized = false
      c.maximized = true
      c:raise()
    end,
    {description = 'maximize without titlebar', group = 'client'}
  ),

  key(
    {alt, shift}, 'F11',
    function(c)
      awful.titlebar.toggle(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    {description = 'toggle maximized and titlebar', group = 'client'}
  )
)

M.titlebar_buttons = join(
  awful.button(
    {}, 1,
    function (c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
    end
  ),
  awful.button(
    {mod}, 1,
    function (c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.move(c)
    end
  ),
  awful.button(
    {mod}, 3,
    function (c)
      c:emit_signal('request::activate', 'mouse_click', {raise = true})
      awful.mouse.client.resize(c)
    end
  )
)

M.mouse = join(
  awful.button({}, 3, function() menu:toggle() end),
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
)

return M


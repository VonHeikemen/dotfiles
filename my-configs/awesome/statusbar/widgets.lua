local gears = require 'gears'
local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local hotkeys_popup = require 'awful.hotkeys_popup'
local lain = require 'lain'
local mod = modkey

-- Load Debian menu entries
local is_debian, debian = pcall(require, 'debian.menu')
local has_fdo, freedesktop = pcall(require, 'freedesktop')

local widget = {}

-- Create main menu
if has_fdo then
  widget.main_menu = freedesktop.menu.build()
else
  local my_awesome_menu = {
    { 'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { 'manual', terminal .. ' -e man awesome' },
    { 'edit config', editor_cmd .. ' ' .. awesome.conffile },
    { 'restart', awesome.restart },
    { 'quit', function() awesome.quit() end },
  }

  local debian_menu = nil

  if is_debian then
    debian_menu = { 'Debian', debian.menu.Debian_menu.Debian }
  end

  local menu_awesome = { 'awesome', my_awesome_menu }
  widget.main_menu = awful.menu({ items = {menu_awesome, debian_menu} })
end

-- Create a textclock widget
widget.textclock = wibox.widget.textclock('%l:%M %p')

-- Attach a calendar widget to the clock
local cal = lain.widget.cal {
  attach_to = {widget.textclock},
  icons = '',
  notification_preset = {
    position = 'top_middle',
    font = 'Monospace 10',
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal
  }
}

-- This ain't necessary. My mouse is broken so I need this right now
widget.textclock:buttons(
  awful.util.table.join(
    awful.button({}, 1, cal.hover_on),
    awful.button({mod}, 1, cal.prev),
    awful.button({mod}, 3, cal.next)
  )
)

widget.textclock:disconnect_signal('mouse::enter', cal.hover_on)

-- Keyboard map indicator and switcher
widget.keyboardlayout = awful.widget.keyboardlayout()

-- Tag actions
widget.taglist = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),

  awful.button(
    {mod}, 1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),

  awful.button({}, 3, awful.tag.viewtoggle),

  awful.button(
    {mod}, 3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end
  ),

  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),

  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Clients list actions
widget.tasklist = gears.table.join(
  awful.button(
    {}, 1,
    function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal(
          'request::activate',
          'tasklist',
          {raise = true}
        )
      end
    end
  ),

  awful.button(
    {}, 3,
    function() awful.menu.client_list({theme = {width = 250}}) end
  ),

  awful.button({}, 4, function() awful.client.focus.byidx(1) end),

  awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

return widget


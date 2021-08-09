local gears = require 'gears'
local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local widget = require 'statusbar.widgets'

local set_wallpaper = function(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper

    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == 'function' then
      wallpaper = wallpaper(s)
    end

    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

-- widget separator
local space = wibox.widget.textbox(' ')

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({'1', '2', '3', '4'}, s, awful.layout.layouts[1])

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(
    gears.table.join(
      awful.button({}, 1, function() awful.layout.inc( 1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc( 1) end),
      awful.button({}, 5, function() awful.layout.inc(-1) end)
    )
  )

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = widget.taglist
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = widget.tasklist,
    style = {
      disable_task_name = true,
    }
  }

  -- Create the wibox
  s.mywibox = awful.wibar({position = 'top', screen = s})

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    expand = 'none',

    -- Left widgets
    {
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
      -- space,
    },

    -- Middle widget
    {
      layout = wibox.layout.flex.horizontal,
      widget.textclock,
    },

    -- Right widgets
    {
      layout = wibox.layout.fixed.horizontal,
      s.mytasklist,
      space,
      s.mylayoutbox,
      space,
      wibox.widget.systray(),
      space
    },
  }
end)


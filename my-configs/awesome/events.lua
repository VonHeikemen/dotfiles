local gears = require 'gears'
local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'

local toggle_tasklist = function(screen)
  local tag_clients = screen.selected_tag:clients() or 99

  if tag_clients == 99 then
    return
  end

  if #tag_clients > 1 then
   screen.mytasklist.visible = true
  else
    screen.mytasklist.visible = tag_clients[1].minimized
  end
end

local update_tag_state = function(screen)
  local next = screen.selected_tag.index
  local last = State.recent_tags.current
  State.recent_tags = {last = last, current = next}
end

-- Signal function to execute when a new client appears.
client.connect_signal('manage', function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then
    awful.client.setslave(c)
  end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
  end

  if c.instance == 'QuakeDD' then
    local clients = c.screen.selected_tag:clients()
    if #clients <= 2 then
      c.screen.mytasklist.visible = false
    end
    awful.placement.top(c, {margins = {top = c.screen.mywibox.height}})
  else
    toggle_tasklist(c.screen)
  end
end)

client.connect_signal('unmanage', function(c)
  toggle_tasklist(c.screen)
end)

screen.connect_signal('tag::history::update', function()
  local screen = awful.screen.focused()
  update_tag_state(screen)
  toggle_tasklist(screen)
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button(
      {}, 1,
      function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.move(c)
      end
    ),

    awful.button(
      {}, 3,
      function()
        c:emit_signal('request::activate', 'titlebar', {raise = true})
        awful.mouse.client.resize(c)
      end
    )
  )

  awful.titlebar(c):setup {
    -- Left
    {
      -- awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },

    -- Middle
    {
      -- Title
      awful.titlebar.widget.titlewidget(c),
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },

    -- Right
    {
      -- awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.minimizebutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      -- awful.titlebar.widget.stickybutton(c),
      -- awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal()
    },

    expand = 'none',
    layout = wibox.layout.align.horizontal
  }
end)

-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal('mouse::enter', function(c)
--     c:emit_signal('request::activate', 'mouse_enter', {raise = false})
-- end)

client.connect_signal('focus', function(c) c.border_color = beautiful.border_focus end)
client.connect_signal('unfocus', function(c) c.border_color = beautiful.border_normal end)


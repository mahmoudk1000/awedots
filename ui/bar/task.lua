local gears            = require("gears")
local awful            = require("awful")
local xresources       = require("beautiful.xresources")
local dpi              = xresources.apply_dpi
local wibox            = require("wibox")

local function rrect(rad)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, rad)
  end
end

local tasklist_buttons = gears.table.join(
  -- Left click
  awful.button({}, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", {raise = true})
    end
  end)
)

return function(s)
  local task = awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    layout = {
      spacing = dpi(5),
      layout = wibox.layout.flex.vertical
    },
    widget_template = {
      {
        {
          id = 'clienticon',
          widget = awful.widget.clienticon,
        },
        margins = dpi(5),
        widget = wibox.container.margin,
      },
      id = 'background_role',
      shape = rrect(2),
      widget = wibox.container.background,
      create_callback = function(self, c)
        self:get_children_by_id('clienticon')[1].client = c
      end,
    }
  }
  return task
end

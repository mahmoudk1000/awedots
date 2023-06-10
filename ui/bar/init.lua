local wibox             = require("wibox")
local xresources        = require("beautiful.xresources")
local dpi               = xresources.apply_dpi
local gears             = require("gears")
local awful             = require("awful")
local beautiful         = require("beautiful")

local sys = require("ui.bar.sys")
local oth = require("ui.bar.oth")

local function rrect(rad)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, rad)
  end
end

local grp = wibox.widget {
  {
    {
      {
        sys.bri,
        sys.net,
        sys.vol,
        sys.bat,
        spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal,
      },
      oth.sep,
      sys.clock,
      layout = wibox.layout.fixed.horizontal,
    },
    left = dpi(2),
    right = dpi(2),
    bottom = dpi(10),
    top = dpi(10),
    widget = wibox.container.margin
  },
  shape = rrect(2),
  widget = wibox.container.background,
}

grp:buttons(gears.table.join(
  awful.button({}, 1, function ()
    s = not s
    if s then
      grp.fg = beautiful.pri
      grp.bg = beautiful.bg_minimize
    else
      grp.bg = beautiful.bg_normal
      grp.fg = beautiful.fg_normal
    end
  end)
))

awful.screen.connect_for_each_screen(function(s)
  awful.wibar({
    position = "bottom",
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
    height = dpi(40),
    screen = s
  }):setup {
    layout = wibox.layout.align.horizontal,
    { -- Top
      {
        require('ui.bar.tag')(s),
        require('ui.bar.task')(s),
        layout = wibox.layout.fixed.horizontal,
      },
      left = dpi(5),
      right = dpi(5),
      widget = wibox.container.margin,
    },
    { -- Middle
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Bottom
      grp,
      left = dpi(5),
      right = dpi(5),
      widget = wibox.container.margin,
    },
  }
end)

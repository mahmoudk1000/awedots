local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local s                 = awful.screen.focused().geometry

local calendar          = require("ui.widget.center.calendar")
local tinyboard         = require("ui.widget.center.tinyboard")
local player            = require("ui.widget.center.player")

local weather_stuff     = require("signal.weather")
local wifi_stuff        = require("signal.wifi")


-- Clock Widget
local time = wibox.widget {
    font    = beautiful.font_bold,
    format  = "%H.%M",
    valign  = "center",
    align   = "center",
    widget  = wibox.widget.textclock,
}

-- Weather Widget
local weather = wibox.widget {
    {
        id      = "desc",
        markup  = "Hot",
        font    = beautiful.font,
        widget  = wibox.widget.textbox
    },
    {
        text = " • ",
        font = beautiful.font,
        widget = wibox.widget.textbox
    },
    {
        id      = "temp",
        markup  = "69" .. "<span>&#176;</span>",
        font    = beautiful.font,
        widget  = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("weather::info", function(temp, desc)
    weather:get_children_by_id("temp")[1]:set_markup(temp .. "<span>&#176;</span>")
    weather:get_children_by_id("desc")[1]:set_markup(desc)
end)

-- Create Center Widget
local center_popup = awful.popup {
    widget = {
        {
            {
                time,
                nil,
                weather,
                layout = wibox.layout.align.horizontal
            },
            margins = { top = dpi(20), left = dpi(20), right = dpi(20) },
            layout  = wibox.container.margin
        },
        {
            {
                tinyboard,
                player,
                calendar,
                forced_width    = s.width / 2.5,
                forced_height   = s.height / 3.5,
                layout          = wibox.layout.flex.horizontal
            },
            margins = dpi(10),
            layout  = wibox.container.margin
        },
        layout = wibox.layout.align.vertical
    },
    ontop           = true,
    visible         = false,
    border_color    = beautiful.border_normal,
    border_width    = beautiful.border_width,
    placement       = function(c)
        awful.placement.bottom(c, { margins = { bottom = dpi(40) }, parent = awful.screen.focused() })
    end,
    shape           = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end
}

-- Toggle the visibility of the calendar popup when clicking on the clock widget
awesome.connect_signal("clock::clicked", function()
    wifi_stuff:emit_wifi_info()
    center_popup.visible = not center_popup.visible
end)

center_popup:connect_signal("mouse::leave", function()
    center_popup.visible = false
end)

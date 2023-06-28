local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi

local calendar          = require("ui.widget.center.calendar")
local tinyboard         = require("ui.widget.center.tinyboard")
local player            = require("ui.widget.center.player")

local weather_stuff     = require("signal.weather")


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
        markup  = weather_stuff.get_desc(),
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
        markup  = weather_stuff.get_temp() .. "<span>&#176;</span>",
        font    = beautiful.font,
        widget  = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("weather::update", function()
    local temp = weather_stuff.get_temp() .. "<span>&#176;</span>"
    local desc = weather_stuff.get_desc()

    weather_stuff:get_children_by_id("desc"):set_markup(desc)
    weather_stuff:get_children_by_id("temp"):set_markup(temp)
end)

-- Create Center Widget
local center_popup = awful.popup {
    widget = {
        {
            {
                { widget = time },
                nil,
                { widget = weather},
                layout = wibox.layout.align.horizontal
            },
            margins = { top = dpi(20), left = dpi(20), right = dpi(20) },
            layout = wibox.container.margin
        },
        {
            { widget = tinyboard },
            { widget = player },
            {
                { widget = calendar },
                margins = dpi(20),
                layout = wibox.container.margin
            },
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.layout.align.vertical
    },
    ontop           = true,
    visible         = false,
    border_color    = beautiful.border_normal,
    border_width    = beautiful.border_width,
    placement = function(c)
        awful.placement.top(c, { margins = { top = dpi(35) }, parent = awful.screen.focused() })
    end,
    shape = function(cr, w, h)
        gears.shape.infobubble(cr, w, h, beautiful.border_radius, dpi(5))
    end,
}

-- Toggle the visibility of the calendar popup when clicking on the clock widget
awesome.connect_signal("clock::clicked", function()
    center_popup.visible = not center_popup.visible
end)

center_popup:connect_signal("mouse::leave", function()
    center_popup.visible = false
end)

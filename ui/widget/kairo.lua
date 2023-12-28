local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require("helpers")

local clock = wibox.widget {
    format = "%H.%M",
    font = beautiful.vont .. "Heavy 40",
    opacity = 0.6,
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

local today = wibox.widget {
    format = "%A",
    font = beautiful.vont .. "Bold Italic 24",
    align = "center",
    valign = "center",
    widget = wibox.widget.textclock
}

local song_name = wibox.widget {
    markup  = "<b>Song</b>",
    font    = beautiful.vont .. "Heavy 14",
    align   = "left",
    valign  = "top",
    widget  = wibox.widget.textbox
}

local song_artist = wibox.widget {
    markup  = "artist",
    font    = beautiful.vont .. "Bold 14",
    align   = "left",
    valign  = "bottom",
    widget  = wibox.widget.textbox
}

local weather_temp = wibox.widget {
    markup = "1" .. "<span>&#176;</span>",
    font = beautiful.font_bold,
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

local weather_desc = wibox.widget {
    markup = "Cold",
    font = beautiful.font_bold,
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

awesome.connect_signal("mpd::info", function(song, artist, _)
    song_name:set_markup(song)
    song_artist:set_markup(artist)
end)

awesome.connect_signal("weather::info", function(temp, desc)
    weather_temp:set_markup(helpers:color_markup(temp .. "<span>&#176;</span>", beautiful.xcolor8))
    weather_desc:set_markup(helpers:color_markup(desc, beautiful.xcolor8))
end)

return awful.popup {
    widget = {
        {
            {
                clock,
                today,
                layout = wibox.layout.stack
            },
            {
                {
                    markup = "|",
                    font = beautiful.vont .. "Heavy 36",
                    widget = wibox.widget.textbox
                },
                margins = { left = dpi(5), right = dpi(5) },
                layout = wibox.container.margin
            },
            {
                song_artist,
                song_name,
                layout = wibox.layout.flex.vertical
            },
            layout = wibox.layout.align.horizontal
        },
        {
            {
                {
                    {
                        {
                            {
                                weather_temp,
                                margins = { right = dpi(10) },
                                layout = wibox.container.margin
                            },
                            weather_desc,
                            layout = wibox.layout.align.horizontal
                        },
                        margins = { left = dpi(5), right = dpi(5) },
                        layout = wibox.container.margin
                    },
                    bg = beautiful.xforeground,
                    shape = function(cr, w, h)
                         gears.shape.rounded_rect(cr, w, h, dpi(3))
                    end,
                    layout = wibox.container.background
                },
                layout = wibox.layout.fixed.horizontal
            },
            margins = { top = dpi(3) },
            layout = wibox.container.margin
        },
        layout = wibox.layout.align.vertical
    },
    bg = "#00000000",
    shape = nil,
    type = "desktop",
    ontop = false,
    visible = true,
    input_passthrough = true,
    placement = function(c)
        awful.placement.top_left(c, { margins = { left = dpi(10) } })
    end
}

local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local wibox     = require("wibox")

local textclock = wibox.widget {
    format = "%k.%M",
    font = beautiful.vont .. "Heavy 40",
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
    font = beautiful.vont .. "Bold 14",
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

local weather_desc = wibox.widget {
    markup = "Cold",
    font = beautiful.vont .. "Bold 14",
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

awesome.connect_signal("mpd::info", function(song, artist, _)
    song_name:set_markup(song)
    song_artist:set_markup(artist)
end)

awesome.connect_signal("weather::info", function(temp, desc)
    weather_temp:set_markup(temp .. "<span>&#176;</span>")
    weather_desc:set_markup(desc)
end)

return awful.popup {
    widget = {
        {
            textclock,
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
                    weather_temp,
                    margins = { right = dpi(10) },
                    layout = wibox.container.margin,
                },
                weather_desc,
                layout = wibox.layout.align.horizontal
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
        awful.placement.top_left(c, { margins = dpi(10) })
    end
}

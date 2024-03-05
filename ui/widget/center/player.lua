local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local res_path          = gears.filesystem.get_configuration_dir() .. "theme/res/"
local recolor           = gears.color.recolor_image

local helpers           = require("helpers")
local mpd_stuff         = require("signal.mpd")


local album_cover = wibox.widget {
    image           = recolor(res_path .. "cover.png", beautiful.xcolor8),
    valign          = "center",
    halign          = "center",
    clip_shape      = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, dpi(4))
    end,
    widget	    = wibox.widget.imagebox
}

local song_name = wibox.widget {
    markup  = "<b>Song</b>",
    font    = beautiful.font_bold,
    align   = "center",
    valign  = "center",
    widget  = wibox.widget.textbox
}

local song_artist = wibox.widget {
    markup  = helpers:color_markup("artist", beautiful.xcolor3),
    font    = beautiful.font,
    align   = "center",
    valign  = "center",
    widget  = wibox.widget.textbox
}

local prev_botton = wibox.widget {
    image           = recolor(res_path .. "prev.png", beautiful.xforeground),
    valign          = "center",
    halign          = "center",
    forced_height   = dpi(10),
    forced_width    = dpi(10),
    buttons = awful.button({}, awful.button.names.LEFT, function()
        awful.spawn({"mpc", "prev"})
    end),
    widget          = wibox.widget.imagebox
}

local toggle_button = wibox.widget {
    image           = recolor(res_path .. "play.png", beautiful.xcolor4),
    valign          = "center",
    halign          = "center",
    forced_height   = dpi(10),
    forced_width    = dpi(10),
    buttons = awful.button({}, awful.button.names.LEFT, function()
        awful.spawn({"mpc", "toggle"})
    end),
    widget          = wibox.widget.imagebox
}

local next_button = wibox.widget {
    image           = recolor(res_path .. "next.png", beautiful.xforeground),
    valign          = "center",
    halign          = "center",
    forced_height   = dpi(10),
    forced_width    = dpi(10),
    buttons = awful.button({}, awful.button.names.LEFT, function()
        awful.spawn({"mpc", "next"})
    end),
    widget          = wibox.widget.imagebox
}

local player = wibox.widget {
    {
        album_cover,
        margins = { top = dpi(0), left = dpi(15), right = dpi(15), bottom = dpi(5) },
        layout = wibox.container.margin
    },
    {
        {
            song_name,
            song_artist,
            layout = wibox.layout.flex.vertical
        },
        margins = { bottom = dpi(5) },
        layout = wibox.container.margin
    },
    {
        {
            prev_botton,
            toggle_button,
            next_button,
            layout = wibox.layout.flex.horizontal
        },
        margins = { left = dpi(6), right = dpi(6), top = dpi(2), bottom = dpi(2) },
        layout = wibox.container.margin
    },
    layout = wibox.layout.ratio.vertical
}
player:adjust_ratio(2, 0.75, 0.15, 0.10)

awesome.connect_signal("mpd::info", function(song, artist, state)
    song_name:set_markup(song)
    song_artist:set_markup(helpers:color_markup(artist, beautiful.xcolor3))

    if state:match("playing") then
        toggle_button.image = recolor(res_path .. "pause.png", beautiful.xcolor4)
    else
        toggle_button.image = recolor(res_path .. "play.png", beautiful.xcolor4)
    end
end)

awesome.connect_signal("mpd::cover", function(isDefault, cover)
    if not isDefault then
        album_cover:set_image(gears.surface.load_uncached(cover))
    else
        album_cover:set_image(recolor(res_path .. "cover.png", beautiful.xcolor8))
    end
end)


return wibox.widget {
    {
        {
            player,
            margins = dpi(10),
            layout = wibox.container.margin
        },
        bg = beautiful.xbackground,
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end,
        layout = wibox.container.background
    },
    margins = dpi(10),
    layout = wibox.container.margin
}

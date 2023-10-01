local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local res_path          = gears.filesystem.get_configuration_dir()
local recolor           = gears.color.recolor_image

local helpers           = require("helpers")
local mpd_stuff         = require("signal.mpd")


local album_cover = wibox.widget {
    image           = recolor(res_path .. "theme/res/cover.png", beautiful.xcolor8),
    valign          = "center",
    halign          = "center",
    forced_height   = dpi(100),
    forced_width    = dpi(100),
    widget          = wibox.widget.imagebox,
    clip_shape      = function(cr, w, h, r)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end
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
    image           = recolor(res_path .. "theme/res/prev.png", beautiful.xforeground),
    valign          = "center",
    halign          = "center",
    forced_height   = dpi(10),
    forced_width    = dpi(10),
    widget          = wibox.widget.imagebox,
    buttons = awful.button({}, awful.button.names.LEFT, function()
        awful.spawn({"mpc", "prev"})
    end)
}

local toggle_button = wibox.widget {
    image           = recolor(res_path .. "theme/res/play.png", beautiful.xcolor4),
    valign          = "center",
    halign          = "center",
    forced_height   = dpi(10),
    forced_width    = dpi(10),
    widget          = wibox.widget.imagebox,
    buttons = awful.button({}, awful.button.names.LEFT, function()
        awful.spawn({"mpc", "toggle"})
    end)
}

local next_button = wibox.widget {
    image           = recolor(res_path .. "theme/res/next.png", beautiful.xforeground),
    valign          = "center",
    halign          = "center",
    forced_height   = dpi(10),
    forced_width    = dpi(10),
    widget          = wibox.widget.imagebox,
    buttons = awful.button({}, awful.button.names.LEFT, function()
        awful.spawn({"mpc", "next"})
    end)
}

local player = wibox.widget {
    {
        { widget = album_cover },
        margins = { top = dpi(0), left = dpi(20), right = dpi(20), bottom = dpi(0) },
        layout = wibox.container.margin
    },
    {
        {widget = song_name},
        {widget = song_artist},
        layout = wibox.layout.align.vertical
    },
    {
        {
            { widget = prev_botton },
            { widget = toggle_button },
            { widget = next_button },
            layout = wibox.layout.flex.horizontal
        },
        margins = dpi(7),
        layout = wibox.container.margin
    },
    layout = wibox.layout.ratio.vertical,
}
player:adjust_ratio(2, 0.65, 0.20, 0.15)


awesome.connect_signal("mpd::info", function(song, artist, state)
    song_name:set_markup(song)
    song_artist:set_markup(helpers:color_markup(artist, beautiful.xcolor3))

    if state:match("playing") then
        toggle_button.image = recolor(res_path .. "theme/res/pause.png", beautiful.xcolor4)
    else
        toggle_button.image = recolor(res_path .. "theme/res/play.png", beautiful.xcolor4)
    end

    player:emit_signal("widget::redraw_needed")
end)


return wibox.widget {
    {
        {
            { widget = player },
            margins = dpi(15),
            layout = wibox.container.margin
        },
        bg = beautiful.xbackground,
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        layout = wibox.container.background,
        forced_width = dpi(250),
        forced_height = dpi(270),
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end
    },
    margins = { top = dpi(20), bottom = dpi(20) },
    layout = wibox.container.margin
}

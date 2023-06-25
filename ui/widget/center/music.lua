local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi


local album_cover = wibox.widget {
    image           = "",
    forced_height   = dpi(85),
    forced_width    = dpi(85),
    widget          = wibox.widget.imagebox
}

local song_name = wibox.widget {
    markup  = "None",
    font    = beautiful.font,
    align   = "center",
    valign  = "center",
    widget  = wibox.widget.textbox
}

local artist_name = {
    markup  = "None",
    font    = beautiful.font,
    align   = "left",
    valign  = "center",
    widget  = wibox.widget.textbox
}

local prev_botton = {
    markup  = "P",
    font    = beautiful.icofont,
    align   = "left",
    valign  = "center",
    widget  = wibox.widget.textbox
}


local toggle_button = {
    markup  = "T",
    font    = beautiful.icofont,
    align   = "center",
    valign  = "center",
    widget  = wibox.widget.textbox
}


local next_button = {
    markup  = "N",
    font    = beautiful.icofont,
    align   = "right",
    valign  = "center",
    widget  = wibox.widget.textbox
}

return wibox.widget {
    {
        { widget = album_cover },
        { 
            { widget = song_name },
            { widget = artist_name },
            layout = wibox.layout.align.vertical
        },
        {
            { widget = prev_botton },
            { widget = toggle_button },
            { widget = next_button },
            layout = wibox.layout.align.horizontal
        },
        spacing = dpi(10),
        layout = wibox.layout.ratio.vertical,
    },
    margins = dpi(10),
    widget = wibox.container.margin,
    forced_width = dpi(230),
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
}

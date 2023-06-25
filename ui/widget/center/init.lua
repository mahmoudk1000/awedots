local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi

local calendar          = require("ui.widget.center.calendar")
local tinyboard        = require("ui.widget.center.tinyboard")

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
    markup  = "Clouded" .. " " .. "21<span>&#176;</span>",
    font    = beautiful.font,
    valign  = "center",
    align   = "right",
    widget  = wibox.widget.textbox,
}


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

-- Create Center Widget
local center_popup = awful.popup {
    widget = {
        {
            {
                { widget = time },
                { widget = weather},
                layout = wibox.layout.align.horizontal
            },
            margins = { top = dpi(20), left = dpi(20), right = dpi(20) },
            layout = wibox.container.margin
        },
        {
            { widget = tinyboard },
            {
                {
                    {
                        { 
                            widget = album_cover
                        },
                        -- {
                        --     { widget = song_name },
                        --     { widget = artist_name },
                        --     layout = wibox.layout.align.vertical
                        -- },
                        -- {
                        --     { widget = prev_botton },
                        --     { widget = toggle_button },
                        --     { widget = next_button },
                        --     layout = wibox.layout.align.horizontal
                        -- },
                        spacing = dpi(10),
                        layout = wibox.layout.ratio.vertical
                    },
                    bg = beautiful.xbackground,
                    border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    layout = wibox.container.background,
                    forced_width = dpi(250),
                    shape = function(cr, w, h)
                        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
                    end,
                },
                margins = { top = dpi(20), bottom = dpi(20) },
                layout = wibox.container.margin
            },
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
        awful.placement.top(c, { margins = { top = dpi(40) }, parent = awful.screen.focused() })
    end,
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
}

-- Toggle the visibility of the calendar popup when clicking on the clock widget
awesome.connect_signal("clock::clicked", function()
    center_popup.visible = not center_popup.visible
end)

center_popup:connect_signal("mouse::leave", function()
    center_popup.visible = false
end)

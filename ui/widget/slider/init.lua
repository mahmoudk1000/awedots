local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require("helpers")
local sys_stuff = require("signal.sys")

local noti      = require("ui.widget.slider.noti")
local info      = require("ui.widget.slider.info")

local weather_temp = wibox.widget {
    markup = "1" .. "<span>&#176;</span>",
    font = beautiful.vont .. "Bold 26",
    align = "right",
    valign = "center",
    widget = wibox.widget.textbox
}

local weather_desc = wibox.widget {
    markup = "Cold AF",
    font = beautiful.vont .. "Bold 13",
    align = "left",
    valign = "center",
    widget = wibox.widget.textbox
}

local weather_land = wibox.widget {
    markup = "Das Land des Gottes",
    font = beautiful.vont .. "11",
    align = "right",
    valign = "center",
    widget = wibox.widget.textbox
}

awesome.connect_signal("weather::info", function(temp, desc, land)
    weather_temp:set_markup(helpers:color_markup(temp .. "<span>&#176;</span>", beautiful.xforeground))
    weather_desc:set_markup(helpers:color_markup(desc, beautiful.xforeground))
    weather_land:set_markup(helpers:color_markup(land, beautiful.xforeground))
end)

local tiktak = gears.timer {
    timeout     = 3,
    autostart   = true,
    call_now    = true,
    callback    = function()
        sys_stuff:emit_sys_info()
    end
}

local function show_slider(s, x)
    local slider_popup

    if (s.width - x) <= dpi(10) then
        slider_popup = awful.popup {
            widget = {
                {
                    {
                        {
                            {
                                weather_temp,
                                nil,
                                {
                                    weather_land,
                                    weather_desc,
                                    layout = wibox.layout.fixed.vertical
                                },
                                layout = wibox.layout.align.horizontal
                            },
                            margins = dpi(10),
                            layout  = wibox.container.margin
                        },
                        shape   = function(cr, w, h)
                            gears.shape.rounded_rect(cr, w, h, dpi(4))
                        end,
                        bg      = beautiful.xcolor0,
                        layout  = wibox.container.background
                    },
                    margins = dpi(10),
                    layout = wibox.container.margin
                },
                noti,
                info,
                layout = wibox.layout.align.vertical
            },
            ontop           = true,
            visible         = true,
            minimum_width   = (20 / 100) * s.width,
            maximum_width   = (20 / 100) * s.width,
            minimum_height  = s.height - dpi(40),
            maximum_height  = s.height - dpi(40),
            border_color    = beautiful.border_normal,
            border_width    = beautiful.border_width,
            placement       = function(c)
                awful.placement.top_right(c)
            end,
            shape           = function (cr, w, h)
                gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
            end
        }

        slider_popup:connect_signal("mouse::leave", function()
            slider_popup.visible = false
            tiktak:stop()
        end)
    end
end

root.buttons(gears.table.join(root.buttons(),
    awful.button({}, awful.button.names.LEFT, function()
        local screen = awful.screen.focused()
        local mouse = mouse.coords()
        tiktak:start()
        show_slider(screen.geometry, mouse.x)
    end)
))

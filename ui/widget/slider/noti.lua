local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local gears     = require("gears")
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require("helpers")


local notifications = {}

local function notification_widget(n)
    local n_title = wibox.widget {
        markup  = n.title,
        font    = beautiful.vont .. "Bold 11",
        align   = "left",
        valign  = "center",
        forced_height = dpi(10),
        widget  = wibox.widget.textbox
    }

    local n_text = wibox.widget {
        markup  = n.message,
        align   = "left",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    return wibox.widget {
        {
            {
                {
                    {
                        {
                            n_title,
                            margins = { bottom = dpi(5) },
                            layout = wibox.container.margin
                        },
                        n_text,
                        layout = wibox.layout.flex.vertical
                    },
                    margins = dpi(15),
                    widget  = wibox.container.margin,
                },
                shape   = function(cr, w, h)
                    gears.shape.rounded_rect(cr, w, h, dpi(2))
                end,
                bg      = beautiful.xbackground,
                widget  = wibox.container.background
            },
            margins = dpi(10),
            layout  = wibox.container.margin
        },
        spacing = dpi(10),
        layout  = wibox.layout.fixed.vertical
    }
end

local function create_notification_container(noties)
    if #noties == 0 then
        return wibox.widget {
            {
                markup  = helpers:color_markup("No Notification", beautiful.xcolor8),
                font    = beautiful.vont .. "Bold 14",
                align   = "center",
                valign  = "center",
                widget  = wibox.widget.textbox
            },
            shape = function(cr, w, h)
                gears.shape.rounded_rect(cr, w, h, dpi(4))
            end,
            bg = beautiful.xcolor0,
            layout = wibox.container.background
        }
    end

    return wibox.widget {
        {
            table.unpack(noties),
            layout  = wibox.layout.align.vertical
        },
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        bg = beautiful.xcolor0,
        layout = wibox.container.background
    }
end

local notification_container = create_notification_container(notifications)

naughty.connect_signal("request::display", function(n)
    table.insert(notifications, notification_widget(n))

    if #notifications >= 8 then
        table.remove(notifications, 8)
    end

    notification_container:set_widget(create_notification_container(notifications))
end)

local dismiss_button = wibox.widget {
    markup          = helpers:color_markup("Dismiss All", beautiful.xbackground),
    align           = "center",
    valign          = "center",
    forced_height   = dpi(40),
    buttons         = awful.button({}, awful.button.names.LEFT, function()
        notifications = {}
        notification_container:set_widget(create_notification_container(notifications))
    end),
    widget          = wibox.widget.textbox
}

return wibox.widget {
    {
        {
            nil,
            notification_container,
            {
                dismiss_button,
                bg = beautiful.xcolor1,
                layout = wibox.container.background
            },
            layout = wibox.layout.align.vertical
        },
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        bg = beautiful.xcolor0,
        layout = wibox.container.background
    },
    margins = dpi(10),
    layout = wibox.container.margin
}

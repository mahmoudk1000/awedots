local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local gears     = require("gears")
local dpi       = beautiful.xresources.apply_dpi

local helpers   = require("helpers")


local notification_container
local notifications = {}

local notification_widget = function(n)
    local n_title = wibox.widget {
        markup = n.title or "Title",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local n_text = wibox.widget {
        markup = n.text or "Message",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    return wibox.widget {
        {
            {
                n_title,
                n_text,
                layout = wibox.layout.fixed.vertical
            },
            margins = dpi(8),
            widget  = wibox.container.margin,
        },
        shape   = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, 4)
        end,
        bg      = beautiful.xbackground,
        widget  = wibox.container.background
    }
end

naughty.connect_signal("destroyed", function(n)
    table.insert(notifications, 1, notification_widget(n))

    if #notifications > 7 then
        table.remove(notifications, 8)
    end

    notification_container = wibox.widget {
        {
            table.unpack(notifications),
            layout = wibox.layout.align.vertical
        },
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        bg = beautiful.xcolor0,
        layout = wibox.container.background
    }

    notification_container:set_widget(notification_container)
    awesome.connect_signal("widget::redraw_needed")
end)

local dismiss_button = wibox.widget {
    markup          = helpers:color_markup("Dismiss All", beautiful.xbackground),
    align           = "center",
    valign          = "center",
    forced_height   = dpi(40),
    buttons         = awful.button({}, awful.button.names.LEFT, function()
        notifications = {}
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

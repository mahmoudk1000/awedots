local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi

local volume_stuff      = require("signal.volume")
local backlight_stuff   = require("signal.backlight")
local bluetooth_stuff   = require("signal.bluetooth")
local wifi_stuff        = require("signal.wifi")
local redshift_stuff    = require("signal.redshift")


-- Wifi Button
local wifi_button = wibox.widget {
    {
        {
            {
                text        = "󰖩 ",
                font        = beautiful.icofont,
                valign      = "center",
                align       = "center",
                widget      = wibox.widget.textbox,
            },
            {
                text    = "WiFi",
                align   = "center",
                font    = beautiful.font,
                widget  = wibox.widget.textbox,
            },
            spacing = dpi(10),
            layout = wibox.layout.flex.vertical,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place
    },
    bg      = beautiful.xcolor4,
    widget  = wibox.container.background,
    shape   = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, awful.button.names.LEFT, function ()
            toggle_wifi_button()
        end)
    }
}

function toggle_wifi_button()
    local status = wifi_stuff.get_status()

    if string.match(status, "On") then
        awful.spawn.with_shell("rfkill block wlan")
        wifi_button.bg = beautiful.xcolor0
    else
        awful.spawn.with_shell("rfkill unblock wlan")
        wifi_button.bg = beautiful.xcolor4
    end
end


-- Bluetooth Button
local bluetooth_button = wibox.widget {
    {
        {
            {
                text        = "",
                font        = beautiful.icofont,
                valign      = "center",
                align       = "center",
                widget      = wibox.widget.textbox,
            },
            {
                text    = "Bluetooth",
                font    = beautiful.font,
                align   = "center",
                widget  = wibox.widget.textbox,
            },
            spacing = dpi(10),
            layout = wibox.layout.flex.vertical,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place
    },
    bg      = bluetooth_stuff.blue_color(),
    widget  = wibox.container.background,
    shape   = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, awful.button.names.LEFT, function ()
            toggle_bluetooth_button()
        end)
    }
}

function toggle_bluetooth_button()
    local status = bluetooth_stuff.get_status()

    if string.match(status, "On") then
        awful.spawn.with_shell("bluetoothctl power off")
        bluetooth_button.bg = beautiful.xcolor0
    else
        awful.spawn.with_shell("bluetoothctl power on")
        bluetooth_button.bg = beautiful.xcolor4
    end
end


-- Redshift Button
local redshift_button = wibox.widget {
    {
        {
            {
                text        = "󱉖",
                font        = beautiful.icofont,
                valign      = "center",
                align       = "center",
                widget      = wibox.widget.textbox,
            },
            {
                text    = "Redshift",
                font    = beautiful.icofont,
                align   = "center",
                widget  = wibox.widget.textbox,
            },
            spacing = dpi(10),
            layout = wibox.layout.flex.vertical,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place
    },
    bg      = beautiful.xcolor4,
    widget  = wibox.container.background,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, awful.button.names.LEFT, function()
            toggle_redshift()
        end)
    }
}

function toggle_redshift()
    local status = redshift_stuff.is_running()

    if string.match(status, "On") then
        awful.spawn.with_shell("systemctl stop --user redshift.service")
        redshift_button.bg = beautiful.xcolor0
    else
        awful.spawn.with_shell("systemctl start --user redshift.service")
        redshift_button.bg = beautiful.xcolor4
    end
end

-- Mic Button
local mic_button = wibox.widget {
    {
        {
            {
                text        = "",
                font        = beautiful.icofont,
                valign      = "center",
                align       = "center",
                widget      = wibox.widget.textbox,
            },
            {
                text    = "On",
                font    = beautiful.icofont,
                widget  = wibox.widget.textbox,
            },
            spacing = dpi(10),
            layout = wibox.layout.flex.vertical,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place
    },
    bg      = beautiful.xcolor4,
    widget  = wibox.container.background,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, 1, function()
            -- Toggle wifi on/off here
            wifi_on = not wifi_on
            mic_button.bg = wifi_on and "#0000FF" or "#000000"
        end)
    }
}


-- Volume Progress
local volume_progress = wibox.widget {
    {
        {
            text    = "󰓃",
            font    = beautiful.icofont,
            widget  = wibox.widget.textbox
        },
        margins = { right = dpi(15), left = dpi(10) },
        layout = wibox.container.margin
    },
    {
        id                  = "text",
        value               = volume_stuff.get_volume(),
        max_value           = 100,
        forced_height       = dpi(30),
        forced_width        = dpi(200),
        color               = beautiful.xcolor4,
        background_color    = beautiful.xcolor0,
        shape               = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
        end,
        widget              = wibox.widget.progressbar
    },
    layout = wibox.layout.align.horizontal,
}

function update_volume_progress()
    local value = volume_stuff.get_volume()

    volume_progress:get_children_by_id("text")[1]:set_value(value)
end

awesome.connect_signal("volume::update", function()
    update_volume_progress()
    volume_progress:emit_signal("widget::redraw_needed")
end)


-- Backlight Progress
local backlight_progress = wibox.widget {
    {
        {
            text    = "󰛨",
            font    = icofont,
            widget  = wibox.widget.textbox
        },
        margins = { right = dpi(15), left = dpi(10) },
        layout = wibox.container.margin
    },
    {
        id                  = "text",
        value               = backlight_stuff.get_backlight(),
        max_value           = 100,
        forced_height       = dpi(30),
        forced_width        = dpi(200),
        color               = beautiful.xcolor4,
        background_color    = beautiful.xcolor0,
        shape               = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
        end,
        widget = wibox.widget.progressbar
    },
    layout = wibox.layout.align.horizontal,
}

function update_backlight_progress()
    local value = backlight_stuff.get_backlight()

    backlight_progress:get_children_by_id("text")[1]:set_value(value)
end

awesome.connect_signal("backlight::update", function()
    update_backlight_progress()
    backlight_progress:emit_signal("widget::redraw_needed")
end)

return wibox.widget {
    {
        {
            {
                { widget = wifi_button },
                margins = { right = dpi(10), bottom = dpi(10) },
                layout = wibox.container.margin
            },
            {
                { widget = bluetooth_button },
                margins = { left = dpi(10), bottom = dpi(10) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.ratio.horizontal 
        },
        {
            {
                { widget = redshift_button },
                margins = { right = dpi(10), top = dpi(10) },
                layout = wibox.container.margin
            },
            {
                { widget = mic_button },
                margins = { left = dpi(10), top = dpi(10) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.ratio.horizontal 
        },
        {
            {
                { widget = volume_progress },
                margins = { top = dpi(20), bottom = dpi(5) },
                layout = wibox.container.margin
            },
            {
                { widget = backlight_progress },
                margins = { top = dpi(5) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.layout.ratio.vertical
    },
    margins = dpi(20),
    layout = wibox.container.margin,
}

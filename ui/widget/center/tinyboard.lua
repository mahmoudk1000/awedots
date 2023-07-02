local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local res_path          = gears.filesystem.get_configuration_dir()

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
                image           = res_path .. "theme/res/wifi.png",
                valign          = "center",
                halign          = "center",
                downscale       = true,
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            {
                text    = "WiFi",
                align   = "center",
                font    = beautiful.font,
                widget  = wibox.widget.textbox,
            },
            spacing = dpi(5),
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
            toggle_wifi()
        end)
    }
}

function toggle_wifi()
    local status = wifi_stuff:get_status()

    if status:match("On") then
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
                image           = res_path .. "theme/res/bluetooth.png",
                valign          = "center",
                halign          = "center",
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            {
                text    = "Bluetooth",
                font    = beautiful.font,
                align   = "center",
                widget  = wibox.widget.textbox
            },
            spacing = dpi(5),
            layout = wibox.layout.flex.vertical,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place
    },
    bg      = bluetooth_stuff:blue_color(),
    widget  = wibox.container.background,
    shape   = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, awful.button.names.LEFT, function ()
            toggle_bluetooth()
        end)
    }
}

function toggle_bluetooth()
    local status = bluetooth_stuff:get_status()

    if status:match("On") then
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
                image           = res_path .. "theme/res/lamp.png",
                valign          = "center",
                halign          = "center",
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            {
                text    = "Redshift",
                font    = beautiful.icofont,
                align   = "center",
                widget  = wibox.widget.textbox,
            },
            spacing = dpi(5),
            layout = wibox.layout.flex.vertical,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place
    },
    bg      = redshift_stuff:get_status(),
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
    local status = redshift_stuff:is_running()

    if status:match("On") then
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
                image           = res_path .. "theme/res/mic.png",
                valign          = "center",
                halign          = "center",
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            {
                text    = "Mic",
                align   = "center",
                font    = beautiful.icofont,
                widget  = wibox.widget.textbox,
            },
            spacing = dpi(5),
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
            toggle_mic()
        end)
    }
}

function toggle_mic()
    local status = volume_stuff:is_mic_on()

    if status:match("On") then
        awful.spawn.with_shell("amixer set Capture nocap")
        mic_button.bg = beautiful.xcolor0
    else
        awful.spawn.with_shell("amixer set Capture cap")
        mic_button.bg = beautiful.xcolor4
    end
end


-- Volume Progress
local volume_progress = wibox.widget {
    {
        {
            image           = res_path .. "theme/res/sound.png",
            valign          = "center",
            halign          = "center",
            forced_height   = dpi(20),
            forced_width    = dpi(20),
            widget          = wibox.widget.imagebox
        },
        margins = { right = dpi(15), left = dpi(10) },
        layout = wibox.container.margin
    },
    {
        id                  = "text",
        value               = volume_stuff:get_volume(),
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
    local value = volume_stuff:get_volume()

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
            image           = res_path .. "theme/res/light.png",
            valign          = "center",
            halign          = "center",
            forced_height   = dpi(20),
            forced_width    = dpi(20),
            widget          = wibox.widget.imagebox
        },
        margins = { right = dpi(15), left = dpi(10) },
        layout = wibox.container.margin
    },
    {
        id                  = "text",
        value               = backlight_stuff:get_backlight(),
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
    local value = backlight_stuff:get_backlight()

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
        forced_width = dpi(250),
        layout = wibox.layout.ratio.vertical
    },
    margins = dpi(20),
    layout = wibox.container.margin,
}

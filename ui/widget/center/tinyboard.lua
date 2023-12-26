local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local res_path          = gears.filesystem.get_configuration_dir() .. "theme/res/"
local recolor           = gears.color.recolor_image

local wifi_stuff        = require("signal.wifi")
local bluetooth_stuff   = require("signal.bluetooth")
local redshift_stuff    = require("signal.redshift")
local volume_stuff      = require("signal.volume")


-- Wifi Button
local wifi_button = wibox.widget {
    {
        {
            {
                id              = "icon",
                image           =  recolor(res_path .. "wifi.png", beautiful.xcolor0),
                valign          = "center",
                halign          = "center",
                downscale       = true,
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            {
                id      = "text",
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
        awful.button({}, awful.button.names.LEFT, function()
            awful.spawn.easy_async_with_shell(
                "iwctl device list | awk '/on/{print $4}'",
                function(stdout)
                    if stdout:match("on") then
                        awful.spawn({"rfkill", "block", "wlan"})
                    else
                        awful.spawn({"rfkill", "unblock", "wlan"})
                    end
                    wifi_stuff:emit_wifi_info()
                end)
        end)
    }
}

awesome.connect_signal("wifi::info", function(is_powerd, is_connected, wifi_name)
    if is_powerd or (is_powerd and is_connected) then
        wifi_button.bg = beautiful.xcolor4
        wifi_button:get_children_by_id("text")[1]:set_text(wifi_name)
        wifi_button:get_children_by_id("icon")[1]:set_image(recolor(res_path.. "wifi.png", beautiful.xcolor0))
    else
        wifi_button.bg = beautiful.xcolor0
        wifi_button:get_children_by_id("text")[1]:set_text(wifi_name)
        wifi_button:get_children_by_id("icon")[1]:set_image(recolor(res_path.. "wifi.png", beautiful.xcolor4))
    end
end)


-- Bluetooth Button
local bluetooth_button = wibox.widget {
    {
        {
            {
                id              = "icon",
                image           = recolor(res_path.. "blue-off.png", beautiful.xcolor0),
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
    bg      = beautiful.xcolor4,
    widget  = wibox.container.background,
    shape   = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, awful.button.names.LEFT, function()
            awful.spawn.easy_async_with_shell(
                "bluetoothctl show | grep -q 'Powered: yes'",
                function(_, _, _, exitcode)
                    local toggle_command = (exitcode == 0) and "bluetoothctl power off" or "bluetoothctl power on"
                    awful.spawn.easy_async(toggle_command, function()
                        bluetooth_stuff:emit_bluetooth_info()
                    end)
                end)
        end)
    }
}

awesome.connect_signal("bluetooth::status", function(status, _, icon)
    if status == "On" then
        bluetooth_button.bg = beautiful.xcolor4
        bluetooth_button:get_children_by_id("icon")[1]:set_image(recolor(icon, beautiful.xcolor0))
    else
        bluetooth_button.bg = beautiful.xcolor0
        bluetooth_button:get_children_by_id("icon")[1]:set_image(icon)
    end
end)


-- Redshift Button
local redshift_button = wibox.widget {
    {
        {
            {
                id              = "icon",
                image           =  recolor(res_path .. "redshift.png", beautiful.xcolor0),
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
    bg      = beautiful.xcolor4,
    widget  = wibox.container.background,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, awful.button.names.LEFT, function()
            awful.spawn.easy_async(
                "systemctl --user is-active --quiet redshift.service",
                function(_, _, _, exitcode)
                    local toggle_command = (exitcode == 0) and "systemctl --user stop redshift.service" or "systemctl --user start redshift.service"
                    awful.spawn.easy_async(toggle_command, function()
                        redshift_stuff:emit_redshift_info()
                    end)
                end)
        end)
    }
}

awesome.connect_signal("redshift::state", function(state)
    if state == "On" then
        redshift_button.bg = beautiful.xcolor4
        redshift_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "redshift.png", beautiful.xcolor0))
    else
        redshift_button.bg = beautiful.xcolor0
        redshift_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "redshift.png", beautiful.xcolor4))
    end
end)


-- Mic Button
local mic_button = wibox.widget {
    {
        {
            {
                id              = "icon",
                image           = recolor(res_path .. "mic.png", beautiful.xcolor0),
                valign          = "center",
                halign          = "center",
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            {
                text    = "Mic",
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
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
    end,
    buttons = {
        awful.button({}, awful.button.names.LEFT, function()
            awful.spawn.easy_async(
                "amixer sget Capture",
                function(stdout)
                    local muted = stdout:match("%[off%]")
                    if muted then
                        awful.spawn({"amixer", "set", "Capture", "cap"})
                    else
                        awful.spawn({"amixer", "set", "Capture", "nocap"})
                    end
                    volume_stuff:emit_mic_state()
                end)
        end)
    }
}

awesome.connect_signal("mic::status", function(status)
    if status == "On" then
        mic_button.bg = beautiful.xcolor4
        mic_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "mic.png", beautiful.xcolor0))
    else
        mic_button.bg = beautiful.xcolor0
        mic_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "mic.png", beautiful.xcolor4))
    end
end)


-- Volume Progress
local volume_progress = wibox.widget {
    {
        id                  = "text",
        value               = 100,
        max_value           = 100,
        color               = beautiful.xcolor4,
        background_color    = beautiful.xcolor0,
        shape               = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
        end,
        widget              = wibox.widget.progressbar
    },
    {
        {
            id = "box",
            {
                image           = res_path .. "sound.png",
                valign          = "center",
                halign          = "center",
                forced_height   = dpi(20),
                forced_width    = dpi(20),
                widget          = wibox.widget.imagebox
            },
            margins = { left = dpi(200) },
            layout = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    },
    forced_height = dpi(50),
    layout = wibox.layout.stack
}

awesome.connect_signal("volume::value", function(value)
    volume_progress:get_children_by_id("text")[1]:set_value(value)
    volume_progress:get_children_by_id("box")[1]:set_margins({ left = dpi(math.min(((value / 100) * 200) + 10, 200)) })
end)


-- Backlight Progress
local backlight_progress = wibox.widget {
    {
        id                  = "text",
        value               = 100,
        max_value           = 100,
        color               = beautiful.xcolor4,
        background_color    = beautiful.xcolor0,
        shape               = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
        end,
        widget = wibox.widget.progressbar
    },
    {
        {
            id = "box",
            {
                id              = "img",
                image           = res_path .. "lamp.png",
                valign          = "center",
                halign          = "left",
                forced_height   = dpi(20),
                forced_width    = dpi(20),
                widget          = wibox.widget.imagebox
            },
            margins = { left = dpi(200) },
            layout = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    },
    forced_height = dpi(50),
    layout = wibox.layout.stack
}

awesome.connect_signal("brightness::value", function(value)
    backlight_progress:get_children_by_id("text")[1]:set_value(value)
    backlight_progress:get_children_by_id("box")[1]:set_margins({ left = dpi(math.min(((value / 100) * 200) + 10, 200)) })
end)

local controls = wibox.widget {
    {
        wifi_button,
        bluetooth_button,
        redshift_button,
        mic_button,
        spacing         = dpi(10),
        forced_num_cols = 2,
        forced_num_rows = 2,
        expand          = true,
        forced_height   = dpi(169),
        layout          = wibox.layout.grid
    },
    volume_progress,
    backlight_progress,
    spacing = dpi(10),
    layout  = wibox.layout.fixed.vertical
}

return wibox.widget {
    controls,
    margins = dpi(10),
    layout  = wibox.container.margin
}

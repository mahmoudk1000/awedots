local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local res_path          = gears.filesystem.get_configuration_dir() .. "theme/res/"
local recolor           = gears.color.recolor_image

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
        awful.button({}, awful.button.names.LEFT, function ()
            wifi_stuff:emit_wifi_info()
        end)
    }
}

awesome.connect_signal("wifi::info", function(is_powerd, is_connected, wifi_name)
    if is_powerd then
        awful.spawn.with_shell("rfkill block wlan")
        wifi_button.bg = beautiful.xcolor0
        wifi_button:get_children_by_id("icon")[1]:set_image(recolor(res_path.. "wifi.png", beautiful.xcolor4))
    else
        awful.spawn.with_shell("rfkill unblock wlan")
        wifi_button.bg = beautiful.xcolor4
        wifi_button:get_children_by_id("icon")[1]:set_image(recolor(res_path.. "wifi.png", beautiful.xcolor0))
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
        awful.button({}, awful.button.names.LEFT, function ()
            toggle_bluetooth()
        end)
    }
}

function toggle_bluetooth()
    awful.spawn.easy_async_with_shell(
        "bluetoothctl show | awk '/Powered: yes/{print \"powerd\"}'", function(stdout, _)
            if stdout and stdout ~= "" then
                awful.spawn.with_shell("bluetoothctl power off")
            elseif stdout == nil or stdout == "" then
                awful.spawn.with_shell("bluetoothctl power on")
            end
        end)
    bluetooth_stuff:emit_bluetooth_info()
end

awesome.connect_signal("bluetooth::status", function(is_powerd, is_connect, icon)
    if is_powerd:match("On") then
        bluetooth_button.bg = beautiful.xcolor4
        bluetooth_button:get_children_by_id("icon")[1]:set_image(recolor(icon, beautiful.xcolor0))
    else
        bluetooth_button.bg = beautiful.xcolor0
        bluetooth_button:get_children_by_id("icon")[1]:set_image(recolor(icon, beautiful.xcolor4))
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
            toggle_redshift()
        end)
    }
}

function toggle_redshift()
    awful.spawn.easy_async_with_shell(
        "systemctl is-active --user redshift | awk '/^active/{print \"on\"}'", function(stdout, _)
            if stdout:match("on") then
                awful.spawn.with_shell("systemctl stop --user redshift.service")
            else
                awful.spawn.with_shell("systemctl start --user redshift.service")
            end
        end)
    redshift_stuff:emit_redshift_info()
end


awesome.connect_signal("redshift::status", function(status)
    if status:match("On") then
        redshift_button.bg = beautiful.xcolor0
        redshift_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "redshift.png", beautiful.xcolor4))
    elseif status:match("Off") then
        redshift_button.bg = beautiful.xcolor4
        redshift_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "redshift.png", beautiful.xcolor0))
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
    awful.spawn.easy_async_with_shell(
        "amixer get Capture | awk '/\\[on\\]/{print \"yes\"}'",
        function(stdout, _)
            if stdout:match("yes") then
                awful.spawn.with_shell("amixer set Capture nocap")
            else
                awful.spawn.with_shell("amixer set Capture cap")
            end
        end)
    volume_stuff:emit_mic_state()
end

awesome.connect_signal("mic::state", function(status)
    if status:match("On") then
        mic_button.bg = beautiful.xcolor0
        mic_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "mic.png", beautiful.xcolor4))
    else
        mic_button.bg = beautiful.xcolor4
        mic_button:get_children_by_id("icon")[1]:set_image(recolor(res_path .. "mic.png", beautiful.xcolor0))
    end
end)


-- Volume Progress
local volume_progress = wibox.widget {
    {
        id                  = "text",
        value               = 100,
        max_value           = 100,
        forced_height       = dpi(65),
        forced_width        = dpi(200),
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
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            margins = { left = dpi(215) },
            layout = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.stack
}

awesome.connect_signal("volume::value", function(value)
    volume_progress:get_children_by_id("text")[1]:set_value(value)
    volume_progress:get_children_by_id("box")[1]:set_margins({ left = dpi(((value / 100) * 200) + 10) })
    volume_progress:emit_signal("widget::redraw_needed")
end)


-- Backlight Progress
local backlight_progress = wibox.widget {
    {
        id                  = "text",
        value               = 100,
        max_value           = 100,
        forced_height       = dpi(100),
        forced_width        = dpi(200),
        color               = beautiful.xcolor4,
        background_color    = beautiful.xcolor0,
        shape               = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
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
                forced_height   = dpi(25),
                forced_width    = dpi(25),
                widget          = wibox.widget.imagebox
            },
            margins = { left = dpi(215) },
            layout = wibox.container.margin
        },
        layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.stack
}

awesome.connect_signal("brightness::value", function(value)
    backlight_progress:get_children_by_id("text")[1]:set_value(value)
    backlight_progress:get_children_by_id("box")[1]:set_margins({ left = dpi(((value / 100) * 200) + 10) })
    backlight_progress:emit_signal("widget::redraw_needed")
end)


local tinyboard = wibox.widget {
    {
        {
            {
                { widget = wifi_button },
                margins = { right = dpi(5) },
                layout = wibox.container.margin
            },
            {
                { widget = bluetooth_button },
                margins = { left = dpi(5) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.ratio.horizontal 
        },
        {
            {
                { widget = redshift_button },
                margins = { right = dpi(5) },
                layout = wibox.container.margin
            },
            {
                { widget = mic_button },
                margins = { left = dpi(5) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.ratio.horizontal 
        },
        spacing = dpi(10),
        layout = wibox.layout.flex.vertical
    },
    { widget = volume_progress },
    { widget = backlight_progress },
    spacing = dpi(10),
    forced_width = dpi(250),
    forced_height = dpi(290),
    layout = wibox.layout.ratio.vertical
}
tinyboard:adjust_ratio(2, 0.50, 0.25, 0.25)

return wibox.widget {
    {
        { widget = tinyboard },
        layout = wibox.layout.fixed.vertical
    },
    margins = dpi(21),
    layout = wibox.container.margin
}

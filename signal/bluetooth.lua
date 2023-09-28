local awful         = require("awful")
local beautiful     = require("beautiful")
local gears         = require "gears"
local res_path      = gears.filesystem.get_configuration_dir()
local recolor       = gears.color.recolor_image


local bluetooth_stuff = {}

local icons = {
    res_path .. "theme/res/blue-con.png",
    res_path .. "theme/res/blue-on.png",
    res_path .. "theme/res/blue-off.png"
}

function bluetooth_stuff:emit_bluetooth_info()
    awful.spawn.easy_async_with_shell(
        "bluetoothctl show | awk '/Powered: yes/{print \"powerd\"}';bluetoothctl info | awk '/Connected: yes/{print \"connected\"}'",
        function(stdout)
            local is_powered = stdout:match("powerd")
            local is_connected = stdout:match("connected")
            local status
            local icon

            if is_powered then
                status = "On"
                if is_connected then
                    icon = recolor(icons[1], beautiful.xcolor4)
                else
                    icon = recolor(icons[2], beautiful.xcolor4)
                end
            else
                status = "Off"
                icon = recolor(icons[3], beautiful.xcolor4)
            end

            awesome.emit_signal("bluetooth::status", status, is_connected, icon)
        end)
end

bluetooth_stuff:emit_bluetooth_info()

return bluetooth_stuff

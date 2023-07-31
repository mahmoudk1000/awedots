local awful         = require("awful")
local beautiful     = require("beautiful")
local gears         = require "gears"
local res_path      = gears.filesystem.get_configuration_dir()
local recolor       = gears.color.recolor_image


local bluetooth_stuff = {}

local icons = {
    res_path .. "theme/res/blue-on.png",
    res_path .. "theme/res/blue-off.png",
    res_path .. "theme/res/blue-con.png"
}

function bluetooth_stuff:emit_bluetooth_info()
    awful.spawn.easy_async_with_shell(
        "bluetoothctl show | awk '/Powered: yes/{print \"powerd\"}';bluetoothctl info | awk '/Connected: yes/{print \"connected\"}'",
        function(stdout, _)
            local is_powerd = stdout:match("powerd")
            local is_connected = stdout:match("connected")
            local icon

            if is_powerd and not is_connected then
                is_powerd = "On"
                icon = recolor(icons[1], beautiful.xcolor4)
            elseif is_powerd and is_connected then
                is_powerd = "On"
                icon = recolor(icons[3], beautiful.xcolor4)
            else
                is_powerd = "Off"
                icon = recolor(icons[2], beautiful.xcolor4)
            end

            awesome.emit_signal("bluetooth::status", is_powerd, is_connected, icon)
        end)
end


return bluetooth_stuff

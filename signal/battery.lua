local awful         = require("awful")
local beautiful     = require("beautiful")
local gears         = require "gears"
local res_path      = gears.filesystem.get_configuration_dir() .. "theme/res/"
local recolor       = gears.color.recolor_image


local battery_stuff = {}

local icon = {
    res_path .. "bat-char.png",
    res_path .. "bat-full.png",
    res_path .. "bat-nor.png"
}

function battery_stuff:emit_battery_info()
    awful.spawn.easy_async_with_shell(
        "cat /sys/class/power_supply/BAT0/capacity; cat /sys/class/power_supply/BAT0/status",
        function(stdout)
            local battery_capacity = stdout:match("(.-)\n")
            local battery_icon

            if stdout:match("Charging") then
                battery_icon = recolor(icon[1], beautiful.xcolor1)
            elseif stdout:match("Full") then
                battery_icon = recolor(icon[2], beautiful.xcolor2)
            elseif stdout:match("Not charging") or stdout:match("Discharging") then
                battery_icon = recolor(icon[3], beautiful.xcolor5)
            end

            awesome.emit_signal("battery::info", battery_capacity, battery_icon)
        end)
end

return battery_stuff

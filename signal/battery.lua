local beautiful = require("beautiful")

local battery_stuff = {}

function battery_stuff:get_battery_status()
    local command = io.popen("cat /sys/class/power_supply/BAT0/status")
    local status = command:read("*all")
    command:close()

    return tostring(status)
end

function battery_stuff:battery_icon()
    status = self:get_battery_status()

    if status:match("Discharging") then
        return beautiful.xcolor1, "󰁹 "
    elseif status:match("Full") then
        return beautiful.xcolor2, "󱟢 "
    else
        return beautiful.xcolor5, "󱟦 "
    end
end

function battery_stuff:get_battery_percent()
    local command = io.popen("cat /sys/class/power_supply/BAT0/capacity")
    local percent = command:read("*all")
    command:close()

    return tonumber(percent)
end

return battery_stuff

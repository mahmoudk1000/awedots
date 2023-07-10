local beautiful     = require("beautiful")
local gears         = require "gears"
local res_path      = gears.filesystem.get_configuration_dir()
local recolor       = gears.color.recolor_image


local battery_stuff = {}

local icon = {
    res_path .. "theme/res/bat-char.png",
    res_path .. "theme/res/bat-full.png",
    res_path .. "theme/res/bat-nor.png",
}

function battery_stuff:get_battery_status()
    local command = io.popen("cat /sys/class/power_supply/BAT0/status")
    local status = command:read("*all")
    command:close()

    return tostring(status)
end

function battery_stuff:battery_icon()
    status = self:get_battery_status()

    if status:match("Discharging") then
        return recolor(icon[3], beautiful.xcolor1)
    elseif status:match("Full") then
        return recolor(icon[2], beautiful.xcolor2)
    else
        return recolor(icon[1], beautiful.xcolor5)
    end
end

function battery_stuff:get_battery_percent()
    local command = io.popen("cat /sys/class/power_supply/BAT0/capacity")
    local percent = command:read("*all")
    command:close()

    return tonumber(percent)
end

return battery_stuff

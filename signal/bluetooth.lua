local beautiful     = require("beautiful")
local gears         = require "gears"
local res_path      = gears.filesystem.get_configuration_dir()
local recolor       = gears.color.recolor_image


local bluetooth_stuff = {}

local icon = {
    res_path .. "theme/res/blue-on.png",
    res_path .. "theme/res/blue-off.png",
    res_path .. "theme/res/blue-con.png"
}

function bluetooth_stuff:get_status()
    local command = io.popen("bluetoothctl show | awk '/Powered: yes/{print \"yes\"}'")
    local status = command:read("*all")
    command:close()

    if status:match("yes") then
        return "On"
    else
        return "Off"
    end
end

function bluetooth_stuff:is_connected()
    local command = io.popen("bluetoothctl info | awk '/Connected: yes/{print \"yes\"}'")
    local is_connected = command:read("*all")
    command:close()

    if is_connected:match("yes") then
        return true
    else
        return false
    end
end

function bluetooth_stuff:bluetooth_icon()
    local status = self:get_status()
    local is_connected = self:is_connected()

    awesome.emit_signal("volume::update")
    if status == "On" and not is_connected then
        return recolor(icon[1], beautiful.xcolor4)
    elseif status == "On" and is_connected then
        return recolor(icon[3], beautiful.xcolor4)
    else
        return recolor(icon[2], beautiful.xcolor4)
    end
end

function bluetooth_stuff:blue_color()
    local status = self:get_status()

    if status:match("On") then
        return beautiful.xcolor4
    else
        return beautiful.xcolor0
    end
end

return bluetooth_stuff

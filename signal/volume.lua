local beautiful     = require("beautiful")
local gears         = require "gears"
local res_path      = gears.filesystem.get_configuration_dir()
local recolor       = gears.color.recolor_image


local volume_stuff = {}

local icon = {
    res_path .. "theme/res/volume.png",
    res_path .. "theme/res/mute.png"
}

function volume_stuff:get_volume()
    local command = io.popen("pamixer --get-volume")
    local percent = command:read("*all")
    command:close()

    if percent == nil or percent == "" then
        return tonumber(100)
    else
        return tonumber(percent)
    end
end

function volume_stuff:is_muted()
    local command = io.popen("pamixer --get-mute")
    local status = command:read("*all")
    command:close()

    if status:match("true") then
	return true
    else
	return false
    end
end

function volume_stuff:volume_icon()
    local muted = self:is_muted()

    if muted then
	return recolor(icon[2], beautiful.xcolor3)
    else
	return recolor(icon[1], beautiful.xcolor3)
    end
end

function volume_stuff:is_mic_on()
    local command  = io.popen("amixer get Capture | tail -n2 | awk '/\\[on\\]/{print \"yes\"}'")
    local status = command:read("*all")
    command:close()

    if status:match("yes") then
	return "On"
    else
	return "Off"
    end
end

return volume_stuff

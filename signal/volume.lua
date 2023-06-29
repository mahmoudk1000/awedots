local volume_stuff = {}

function volume_stuff:get_volume()
    local command = io.popen("pamixer --get-volume")
    local status = command:read("*all")
    command:close()

    return tonumber(status)
end

function volume_stuff:is_muted()
    local command = io.popen("pamixer --get-mute")
    local status = command:read("*all")
    command:close()

    if string.match(status, "true") then
	return true
    else
	return false
    end
end

function volume_stuff:volume_icon()
    local muted = self:is_muted()
    if muted then
	return "󱄡 "
    else
	return "󱄠 "
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

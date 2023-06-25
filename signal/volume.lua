local volume_stuff = {}

function volume_stuff.get_volume()
    local command = io.popen("pamixer --get-volume")
    local status = command:read("*all")
    command:close()

    return tonumber(status)
end

function volume_stuff.is_muted()
    local command = io.popen("pamixer --get-mute")
    local status = command:read("*all")
    command:close()

    if string.match(status, "true") then
	return true
    else
	return false
    end
end

function volume_stuff.volume_icon()
    local muted = volume_stuff.is_muted()
    if muted then
	return "󱄡 "
    else
	return "󱄠 "
    end
end

return volume_stuff

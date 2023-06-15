local bluetooth_stuff = {}

function bluetooth_stuff.get_status()
    local command = io.popen("bluetoothctl show | awk '/Powered: yes/{print \"yes\"}'")
    local status = command:read("*all")
    command:close()

    if string.match(status, "yes") then
        return "On"
    else
        return "Off"
    end
end

function bluetooth_stuff.is_connected()
    local command = io.popen("bluetoothctl info | awk '/Connected: yes/{print \"yes\"}'")
    local is_connected = command:read("*all")
    command:close()

    if string.match(is_connected, "yes") then
        return true
    else
        return false
    end
end

function bluetooth_stuff.bluetooth_icon()
    local status = bluetooth_stuff.get_status()
    local is_connected = bluetooth_stuff.is_connected()

    if status == "On" and not is_connected then
        return "󰂯 "
    elseif status == "On" and is_connected then
        return "󰂱 "
    else
        return "󰂲 "
    end
end

return bluetooth_stuff

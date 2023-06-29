local wifi_stuff = {}

function wifi_stuff:get_status()
    local command = io.popen("iwctl device list | awk '/on/{print $4}'")
    local status = command:read("*all")
    command:close()

    if status:match("on") then
        return "On"
    else
        return "Off"
    end
end 

function wifi_stuff:is_connected()
    local command = io.popen("iwctl station wlan0 get-networks | grep '>'")
    local is_connected = command:read("*all")
    command:close()

    if is_connected then
        return true
    else
        return false
    end
end

function wifi_stuff:wifi_name()
    local connected = self:is_connected()
    
    if connected then
        local command = io.popen("iwctl station wlan0 get-networks | grep '>' | awk '{print $4}'")
        local name = command:read("*all")
        command:close()

        return name
    else
        return "WiFi"
    end
end


return wifi_stuff

local backlight_stuff = {}

function backlight_stuff:get_backlight()
    local command = io.popen("brightnessctl info")
    local percent = command:read("*all")
    command:close()

    return tonumber(string.match(percent, "(%d+)%%"))
end

return backlight_stuff

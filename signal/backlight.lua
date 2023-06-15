local backlight_stuff = {}

function backlight_stuff.get_backlight()
    local command = io.popen("light -G")
    local percent = command:read("*all")
    command:close()

    return tonumber(string.match(percent, "(.*)%."))
end

return backlight_stuff

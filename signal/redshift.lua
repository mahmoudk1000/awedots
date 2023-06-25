local redshift_stuff = {}

function redshift_stuff.is_running()
    local command = io.popen("systemctl is-active --user redshift | awk '/^active/{print \"yes\"}'")
    local status = command:read("*all")
    command:close()

    if status:match("yes") then
        return "On"
    else
        return "Off"
    end
end

return redshift_stuff

local beautiful     = require("beautiful")

local redshift_stuff = {}

function redshift_stuff:is_running()
    local command = io.popen("systemctl is-active --user redshift | awk '/^active/{print \"yes\"}'")
    local status = command:read("*all")
    command:close()

    if status:match("yes") then
        return "On"
    else
        return "Off"
    end
end

function redshift_stuff:get_status()
    local status = self:is_running()

    if status:match("On") then
        return beautiful.xcolor4
    else
        return beautiful.xcolor0
    end
end

return redshift_stuff

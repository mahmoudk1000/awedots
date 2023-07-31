local awful         = require("awful")
local beautiful     = require("beautiful")


local redshift_stuff = {}

function redshift_stuff:emit_redshift_info()
    awful.spawn.easy_async_with_shell(
        "systemctl is-active --user redshift | awk '/^active/{print \"on\"}'",
        function(stdout, _)
            local status
            local color

            if stdout:match("on") then
                status = "On"
                color = beautiful.xcolor4
            else
                status = "Off"
                color = beautiful.xcolor0
            end

            awesome.emit_signal("redshift::status", status, color)
        end)
end

return redshift_stuff

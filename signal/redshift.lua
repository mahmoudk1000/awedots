local awful         = require("awful")


local redshift_stuff = {}

function redshift_stuff:emit_redshift_info()
    awful.spawn.easy_async_with_shell(
        "systemctl is-active --user redshift | awk '/^active/{print \"on\"}'",
        function(stdout, _)
            local status

            if stdout:match("on") then
                status = "On"
            else
                status = "Off"
            end

            awesome.emit_signal("redshift::status", status)
        end)
end

return redshift_stuff

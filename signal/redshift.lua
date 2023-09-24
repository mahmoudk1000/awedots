local awful = require("awful")


local redshift_stuff = {}

function redshift_stuff:emit_redshift_info()
    awful.spawn.easy_async(
        "systemctl --user is-active --quiet redshift.service",
        function(_, _, _, exitcode)
            local state

            if exitcode == 0 then
                state = "On"
            else
                state = "Off"
            end

            awesome.emit_signal("redshift::state", state)
        end)
end

redshift_stuff:emit_redshift_info()

return redshift_stuff

local awful = require("awful")


local wifi_stuff = {}

function wifi_stuff:emit_wifi_info()
    awful.spawn.easy_async_with_shell(
        "iwctl device list | awk '/on/{print $4}';iwctl station wlan0 show | awk '/State/ {print $NF}';iwctl station wlan0 show | awk '/Connected network/ {print $NF}'",
        function(stdout)
            local is_powerd = stdout:match("^(on)\n")
            local is_connected = stdout:match("\n(connected)\n")
            local wifi_name

            if is_powerd and is_connected then
                wifi_name = stdout:match("[^\n]+\n[^\n]+\n([^\n]+)")
            else
                wifi_name = "Wifi"
            end

            awesome.emit_signal("wifi::info", is_powerd, is_connected, wifi_name)
        end)
end

wifi_stuff:emit_wifi_info()

return wifi_stuff

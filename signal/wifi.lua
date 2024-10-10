local awful = require("awful")

local icons = {
	"wifi.png",
	"no-wifi.png",
}

local M = {}

function M:emit_wifi_info()
	awful.spawn.easy_async_with_shell(
		"iwctl device list | awk '/on/{print $4}';iwctl station wlan0 show | awk '/State/ {print $NF}';iwctl station wlan0 show | awk '/Connected network/ {for (i=3; i<=NF; i++) printf $i (i<NF ? OFS : ORS)}'",
		function(stdout)
			local is_powerd = stdout:match("^(on)\n") and true or false
			local is_connected = stdout:match("\n(connected)\n") and true or false
			local icon, ssid

			if is_powerd and is_connected then
				ssid = stdout:match("[^\n]+\n[^\n]+\n([^\n]+)")
				icon = icons[1]
			elseif is_powerd and not is_connected then
				ssid = "Disconnected"
				icon = icons[1]
			else
				ssid = "Offline"
				icon = icons[2]
			end

			awesome.emit_signal("wifi::status", is_powerd, is_connected, icon, ssid)
		end
	)
end

M:emit_wifi_info()

return M

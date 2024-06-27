local awful = require("awful")

local M = {}

function M:emit_wifi_info()
	awful.spawn.easy_async_with_shell(
		"iwctl device list | awk '/on/{print $4}';iwctl station wlan0 show | awk '/State/ {print $NF}';iwctl station wlan0 show | awk '/Connected network/ {print $NF}'",
		function(stdout)
			local is_powerd = stdout:match("^(on)\n")
			local is_connected = stdout:match("\n(connected)\n")
			local ssid

			if is_powerd and is_connected then
				ssid = stdout:match("[^\n]+\n[^\n]+\n([^\n]+)")
			else
				ssid = "Wifi"
			end

			awesome.emit_signal("wifi::info", is_powerd, is_connected, ssid)
		end
	)
end

M:emit_wifi_info()

return M

local awful = require("awful")

local M = {}

local icons = {
	"blue-con.png",
	"blue-on.png",
	"blue-off.png",
}

function M:emit_bluetooth_info()
	awful.spawn.easy_async_with_shell(
		"bluetoothctl show | awk '/Powered: yes/{print \"powerd\"}';bluetoothctl info | awk '/Connected: yes/{print \"connected\"}'",
		function(stdout)
			local status = stdout:match("powerd")
			local is_connected = stdout:match("connected")
			local is_powerd = false
			local icon

			if status then
				is_powerd = true
				if is_connected then
					icon = icons[1]
				else
					icon = icons[2]
				end
			else
				icon = icons[3]
			end

			awesome.emit_signal("bluetooth::status", is_powerd, is_connected, icon)
		end
	)
end

M:emit_bluetooth_info()

return M

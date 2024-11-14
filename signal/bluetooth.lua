local awful = require("awful")
local gears = require("gears")
local icons = require("icons")

local M = {}

function M:emit_bluetooth_info()
	awful.spawn.easy_async_with_shell(
		"bluetoothctl show | awk '/Powered: yes/{print \"powerd\"}';bluetoothctl info | awk '/Connected: yes/{print \"connected\"}'",
		function(stdout)
			local is_powerd = stdout:match("powerd") and true or false
			local is_connected = stdout:match("connected") and true or false
			local icon

			if is_powerd and is_connected then
				icon = icons.bluetooth.pair
			elseif is_powerd and not is_connected then
				icon = icons.bluetooth.on
			else
				icon = icons.bluetooth.off
			end

			awesome.emit_signal("bluetooth::status", is_powerd, is_connected, icon)
		end
	)
end

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		M:emit_bluetooth_info()
	end,
})

return M

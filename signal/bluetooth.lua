local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local res_path = gears.filesystem.get_configuration_dir()
local recolor = gears.color.recolor_image

local M = {}

local icons = {
	res_path .. "theme/res/blue-con.png",
	res_path .. "theme/res/blue-on.png",
	res_path .. "theme/res/blue-off.png",
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
					icon = recolor(icons[1], beautiful.xcolor4)
				else
					icon = recolor(icons[2], beautiful.xcolor4)
				end
			else
				icon = recolor(icons[3], beautiful.xcolor4)
			end

			awesome.emit_signal("bluetooth::status", is_powerd, is_connected, icon)
		end
	)
end

M:emit_bluetooth_info()

return M

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")

local M = {}

local icons = {
	"bat-char.png",
	"bat-full.png",
	"bat-nor.png",
	"lighting.png",
}

function M:emit_battery_info()
	awful.spawn.easy_async_with_shell(
		"cat /sys/class/power_supply/BAT0/capacity; cat /sys/class/power_supply/BAT0/status",
		function(stdout)
			local capacity = tonumber(stdout:match("(%d+)\n"))
			local status = stdout:match("\n(.-)\n?$")
			local icon

			if status == "Charging" then
				icon = helpers:recolor(icons[1], beautiful.xcolor1)
			elseif status == "Full" then
				icon = helpers:recolor(icons[2], beautiful.xcolor2)
			else
				icon = helpers:recolor(icons[3], beautiful.xcolor5)
			end

			awesome.emit_signal("battery::info", capacity, status, icon)
		end
	)
end

gears.timer({
	timeout = 15,
	autostart = true,
	call_now = true,
	callback = function()
		M:emit_battery_info()
	end,
})

return M

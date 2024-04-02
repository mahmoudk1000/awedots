local awful = require("awful")

local M = {}

function M:emit_backlight_info()
	awful.spawn.easy_async("brightnessctl info", function(stdout)
		local value = stdout:match("(%d+)%%")
		awesome.emit_signal("brightness::value", tonumber(value))
	end)
end

M:emit_backlight_info()

return M

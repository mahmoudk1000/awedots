local awful = require("awful")
local beautiful = require("beautiful")

local helpers = require("helpers")

local M = {}

local icon = {
	"volume.png",
	"mute.png",
}

function M:emit_volume_state()
	awful.spawn.easy_async_with_shell("pamixer --get-volume;pamixer --get-mute", function(stdout)
		local volume_percent = tonumber(stdout:match("(.-)\n"))
		local is_muted = stdout:match("\n(true)\n")
		local volume_icon

		if volume_percent == nil or volume_percent == "" then
			volume_percent = tonumber(100)
		end

		if is_muted then
			volume_icon = helpers:recolor(icon[2], beautiful.xcolor3)
		else
			volume_icon = helpers:recolor(icon[1], beautiful.xcolor3)
		end

		awesome.emit_signal("volume::value", volume_percent, volume_icon)
	end)
end

function M:emit_mic_state()
	awful.spawn.easy_async("amixer sget Capture", function(stdout)
		local is_muted = stdout:match("%[off%]") and true or false
		awesome.emit_signal("mic::status", is_muted)
	end)
end

M:emit_volume_state()
M:emit_mic_state()

return M

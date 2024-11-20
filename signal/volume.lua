local awful = require("awful")
local gears = require("gears")
local icons = require("icons")

local M = {}

function M:emit_volume_state()
	awful.spawn.easy_async_with_shell("pamixer --get-volume;pamixer --get-mute", function(stdout)
		local percent = tonumber(stdout:match("(.-)\n")) or 0
		local is_muted = stdout:match("\n(true)") or false
		local icon

		if is_muted then
			icon = icons.volume.mute
		else
			if percent >= 70 then
				icon = icons.volume.high
			elseif percent >= 35 then
				icon = icons.volume.medium
			else
				icon = icons.volume.low
			end
		end

		awesome.emit_signal("volume::value", percent, icon, is_muted)
	end)
end

function M:emit_mic_state()
	awful.spawn.easy_async("pamixer --default-source --get-mute", function(stdout)
		local is_muted = stdout:match("true") and true or false
		awesome.emit_signal("mic::status", is_muted)
	end)
end

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		M:emit_volume_state()
		M:emit_mic_state()
	end,
})

return M

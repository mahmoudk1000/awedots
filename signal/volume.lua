local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")

local M = {}

local icons = {
	"volume.png",
	"mute.png",
}

function M:emit_volume_state()
	awful.spawn.easy_async_with_shell("pamixer --get-volume;pamixer --get-mute", function(stdout)
		local percent = tonumber(stdout:match("(.-)\n"))
		local is_muted = stdout:match("\n(true)\n")
		local icon

		if percent == nil or percent == "" then
			percent = tonumber(100)
		end

		if is_muted then
			icon = helpers:recolor(icons[2], beautiful.xcolor3)
		else
			icon = helpers:recolor(icons[1], beautiful.xcolor3)
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

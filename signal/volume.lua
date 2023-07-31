local awful	    = require("awful")
local beautiful     = require("beautiful")
local gears         = require "gears"
local res_path      = gears.filesystem.get_configuration_dir()
local recolor       = gears.color.recolor_image


local volume_stuff = {}

local icon = {
    res_path .. "theme/res/volume.png",
    res_path .. "theme/res/mute.png"
}

function volume_stuff:emit_volume_state()
    awful.spawn.easy_async_with_shell(
	"pamixer --get-volume; pamixer --get-mute",
	function(stdout, _)
	    local volume_percent = stdout:match("(.-)\n")
	    local is_muted = stdout:match("\n(true)\n")

	    if volume_percent == nil or volume_percent == "" then
		volume_percent = tonumber(100)
	    end

	    if is_muted then
		volume_icon = recolor(icon[2], beautiful.xcolor3)
	    else
		volume_icon = recolor(icon[1], beautiful.xcolor3)
	    end

	    awesome.emit_signal("volume::value", tonumber(volume_percent), volume_icon)
    end)
end

function volume_stuff:emit_mic_state()
    awful.spawn.easy_async_with_shell(
	"amixer get Capture | awk '/\\[on\\]/{print \"yes\"}'",
	function(stdout, _)
	    if stdout:match("yes") then
		awesome.emit_signal("mic::state", "On")
	    else
		awesome.emit_signal("mic::state", "Off")
	    end
	end)
end

return volume_stuff

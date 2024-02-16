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
	"pamixer --get-volume;pamixer --get-mute",
	function(stdout)
	    local volume_percent = tonumber(stdout:match("(.-)\n"))
	    local is_muted = stdout:match("\n(true)\n")
	    local volume_icon

	    if volume_percent == nil or volume_percent == "" then
		volume_percent = tonumber(100)
	    end

	    if is_muted then
		volume_icon = recolor(icon[2], beautiful.xcolor3)
	    else
		volume_icon = recolor(icon[1], beautiful.xcolor3)
	    end

	    awesome.emit_signal("volume::value", volume_percent, volume_icon)
	end)
end

function volume_stuff:emit_mic_state()
    awful.spawn.easy_async(
	"amixer sget Capture",
	function(stdout)
	    local is_muted = stdout:match("%[off%]")
	    local status

	    if is_muted then
		status = "Off"
	    else
		status = "On"
	    end

	    awesome.emit_signal("mic::status", status)
	end)
end

volume_stuff:emit_volume_state()
volume_stuff:emit_mic_state()

return volume_stuff

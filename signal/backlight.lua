local awful = require("awful")


local backlight_stuff = {}

function backlight_stuff:emit_backlight_info()
    awful.spawn.easy_async(
	"brightnessctl info",
	function(stdout)
	    local value = stdout:match("(%d+)%%")
        awesome.emit_signal("brightness::value", tonumber(value))
    end)
end

backlight_stuff:emit_backlight_info()

return backlight_stuff

local awful = require("awful")


local backlight_stuff = {}

function backlight_stuff:emit_backlight_info()
    awful.spawn.easy_async_with_shell(
	"brightnessctl info", function(stdout, _)
	    local value = stdout:match("(%d+)%%")
        awesome.emit_signal("brightness::value", tonumber(value))
    end)
end

return backlight_stuff

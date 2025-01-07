local awful = require("awful")

local layoutbox = function(s)
	return awful.widget.layoutbox({
		screen = s,
		buttons = {
			awful.button({}, awful.button.names.LEFT, function()
				awful.layout.inc(1)
			end),
			awful.button({}, awful.button.names.RIGHT, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, awful.button.names.SCROLL_UP, function()
				awful.layout.inc(1)
			end),
			awful.button({}, awful.button.names.SCROLL_DOWN, function()
				awful.layout.inc(-1)
			end),
		},
	})
end

return layoutbox

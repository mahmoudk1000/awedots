local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local volume = wibox({
	visible = false,
	ontop = true,
	width = dpi(190),
	height = dpi(70),
})

local icon = wibox.widget({
	image = helpers:recolor("volume.png"),
	valign = "center",
	halign = "center",
	forced_width = dpi(20),
	forced_height = dpi(20),
	widget = wibox.widget.imagebox,
})

local slider = wibox.widget({
	id = "slider",
	value = 100,
	handle_border_color = beautiful.xbackground,
	handle_border_width = dpi(5),
	handle_color = beautiful.xcolor4,
	handle_width = dpi(10),
	handle_shape = helpers:rrect(),
	bar_active_color = beautiful.xcolor4,
	bar_color = beautiful.xcolor8,
	bar_height = dpi(10),
	bar_shape = helpers:rrect(8),
	widget = wibox.widget.slider,
})

volume:setup({
	{
		icon,
		{
			slider,
			margins = { left = dpi(10), top = dpi(10), bottom = dpi(10) },
			layout = wibox.container.margin,
		},
		nil,
		layout = wibox.layout.align.horizontal,
	},
	margins = { left = dpi(15), right = dpi(15), top = dpi(10), bottom = dpi(10) },
	layout = wibox.container.margin,
})

local timer = gears.timer({
	timeout = 2,
	single_shot = true,
	callback = function()
		volume.visible = false
	end,
})

awesome.connect_signal("volume::value", function(value, _, is_muted)
	slider:set_value(value)

	if is_muted then
		icon.image = helpers:recolor("mute.png", beautiful.xcolor1)
	else
		icon.image = helpers:recolor("volume.png")
	end
end)

awesome.connect_signal("volume::pop", function()
	awesome.emit_signal("backlight::hide")

	awful.placement.bottom(volume, {
		margins = { bottom = beautiful.bar_height + (beautiful.useless_gap * 2) },
		parent = awful.screen.focused(),
	})

	volume.visible = true
	timer:again()
end)

awesome.connect_signal("volume::hide", function()
	volume.visible = false
end)

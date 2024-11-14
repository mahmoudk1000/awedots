local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local icons = require("icons")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local backlight = wibox({
	visible = false,
	ontop = true,
	width = dpi(190),
	height = dpi(70),
})

local icon = wibox.widget({
	image = helpers:recolor(icons.brightness),
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

backlight:setup({
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
		backlight.visible = false
	end,
})

awesome.connect_signal("brightness::value", function(value)
	slider:set_value(value)
end)

awesome.connect_signal("backlight::pop", function()
	awesome.emit_signal("volume::hide")

	awful.placement.bottom(backlight, {
		margins = { bottom = beautiful.bar_height + (beautiful.useless_gap * 2) },
		parent = awful.screen.focused(),
	})

	backlight.visible = true
	timer:again()
end)

awesome.connect_signal("backlight::hide", function()
	backlight.visible = false
end)

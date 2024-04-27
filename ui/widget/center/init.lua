local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local s = awful.screen.focused().geometry

local helpers = require("helpers")

local calendar = require(... .. ".calendar")
local tinyboard = require(... .. ".tinyboard")
local player = require(... .. ".player")

local weather_stuff = require("signal.weather")
local wifi_stuff = require("signal.wifi")

-- Clock Widget
local time = wibox.widget({
	font = beautiful.font_bold,
	format = "%H.%M",
	valign = "center",
	align = "center",
	widget = wibox.widget.textclock,
})

-- Weather Widget
local weather = wibox.widget({
	{
		id = "desc",
		markup = "Hot",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	},
	{
		text = " • ",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	},
	{
		id = "temp",
		markup = "69" .. "<span>&#176;</span>",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal,
})

awesome.connect_signal("weather::info", function(temp, desc)
	weather:get_children_by_id("temp")[1]:set_markup(temp .. "<span>&#176;</span>")
	weather:get_children_by_id("desc")[1]:set_markup(desc)
end)

local center_controls = wibox.widget({
	{
		tinyboard.toggles,
		{
			tinyboard.sliders,
			player,
			layout = wibox.layout.flex.horizontal,
		},
		layout = wibox.layout.align.vertical,
	},
	calendar(),
	forced_width = s.width / 2.5,
	forced_height = s.height / 4,
	layout = wibox.layout.ratio.horizontal,
})

center_controls:adjust_ratio(2, 2 / 3, 1 / 3, 0)

-- Create Center Widget
local center_popup = awful.popup({
	widget = {
		{
			{
				{
					time,
					nil,
					weather,
					layout = wibox.layout.align.horizontal,
				},
				margins = dpi(5),
				layout = wibox.container.margin,
			},
			center_controls,
			layout = wibox.layout.align.vertical,
		},
		margins = dpi(10),
		layout = wibox.container.margin,
	},
	ontop = true,
	visible = false,
	border_color = beautiful.border_normal,
	border_width = beautiful.border_width,
	shape = helpers:rrect(),
	placement = function(c)
		awful.placement.bottom(
			c,
			{ margins = { bottom = dpi(30) + (beautiful.useless_gap * 2) }, parent = awful.screen.focused() }
		)
	end,
})

-- Toggle the visibility of the calendar popup when clicking on the clock widget
awesome.connect_signal("clock::clicked", function()
	wifi_stuff:emit_wifi_info()
	center_popup.visible = not center_popup.visible
end)

center_popup:connect_signal("mouse::leave", function()
	center_popup.visible = false
end)

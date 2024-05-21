local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
--
-- Signals
local volume_stuff = require("signal.volume")
local battery_stuff = require("signal.battery")
local bluetooth_stuff = require("signal.bluetooth")

-- Clock
local clock = wibox.widget({
	{
		{
			image = helpers:recolor("clock.png", beautiful.xcolor2),
			valign = "center",
			align = "center",
			widget = wibox.widget.imagebox,
		},
		margins = { right = dpi(5) },
		layout = wibox.container.margin,
	},
	{
		format = "%a %d %b, ",
		font = beautiful.font,
		valign = "center",
		align = "center",
		widget = wibox.widget.textclock,
	},
	{
		format = "%R",
		font = beautiful.font_bold,
		halign = "center",
		valign = "center",
		widget = wibox.widget.textclock,
	},
	buttons = gears.table.join(awful.button({}, awful.button.names.LEFT, nil, function()
		awesome.emit_signal("clock::clicked")
	end)),
	layout = wibox.layout.fixed.horizontal,
})

local function sys_tray(icon, color)
	return wibox.widget({
		{
			{
				id = "icon",
				image = helpers:recolor(icon, color),
				halign = "center",
				valign = "center",
				widget = wibox.widget.imagebox,
			},
			margins = { right = dpi(4) },
			layout = wibox.container.margin,
		},
		{
			id = "text",
			text = "100%",
			font = beautiful.font,
			halign = "center",
			valign = "center",
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.horizontal,
	})
end

-- Volume Widget
local volume = sys_tray("volume.png", beautiful.xcolor3)

awesome.connect_signal("volume::value", function(value, icon)
	volume:get_children_by_id("icon")[1]:set_image(icon)
	volume:get_children_by_id("text")[1]:set_text(value .. "%")
end)

-- Backlight Widget
local backlight = sys_tray("lamp.png", beautiful.xcolor2)

awesome.connect_signal("brightness::value", function(value)
	backlight:get_children_by_id("text")[1]:set_text(value .. "%")
end)

-- Bluetooth Widget
local bluetooth = sys_tray("blue-on.png", beautiful.xcolor4)

awesome.connect_signal("bluetooth::status", function(is_powerd, _, icon)
	bluetooth:get_children_by_id("icon")[1]:set_image(icon)
	bluetooth:get_children_by_id("text")[1]:set_text(is_powerd and "On" or "Off")
end)

gears.timer({
	timeout = 5,
	autostart = true,
	call_now = true,
	callback = function()
		bluetooth_stuff:emit_bluetooth_info()
		volume_stuff:emit_volume_state()
	end,
})

-- Battery Widget
local battery = sys_tray("bat-nor.png", beautiful.xcolor5)

awesome.connect_signal("battery::info", function(value, icon)
	battery:get_children_by_id("icon")[1]:set_image(icon)
	battery:get_children_by_id("text")[1]:set_text(value .. "%")
end)

gears.timer({
	timeout = 30,
	autostart = true,
	call_now = true,
	callback = function()
		battery_stuff:emit_battery_info()
	end,
})

return {
	clock = clock,
	volume = volume,
	backlight = backlight,
	bluetooth = bluetooth,
	battery = battery,
}

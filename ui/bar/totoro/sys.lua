local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")
local helpers = require("helpers")
--
-- Clock
local clock = wibox.widget({
	{
		{
			image = helpers:recolor(icons.clock, beautiful.xcolor2),
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
		center_toggle()
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
local volume = sys_tray(icons.volume.mute, beautiful.xcolor3)

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
	bluetooth:get_children_by_id("icon")[1]:set_image(helpers:recolor(icon))
	bluetooth:get_children_by_id("text")[1]:set_text(is_powerd and "On" or "Off")
end)

-- Battery Widget
local battery = sys_tray("bat-nor.png", beautiful.xcolor5)

awesome.connect_signal("battery::info", function(capacity, _, icon)
	battery:get_children_by_id("icon")[1]:set_image(icon)
	battery:get_children_by_id("text")[1]:set_text(capacity .. "%")
end)

return {
	clock = clock,
	volume = volume,
	backlight = backlight,
	bluetooth = bluetooth,
	battery = battery,
}

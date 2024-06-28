local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
--
-- Clock
local clock = wibox.widget({
	{
		format = "%a %d %b, ",
		font = beautiful.vont .. "Aile Oblique Heavy 10",
		valign = "center",
		align = "center",
		widget = wibox.widget.textclock,
	},
	{
		format = "%R",
		font = beautiful.vont .. "Aile Oblique Heavy 10",
		halign = "center",
		valign = "center",
		widget = wibox.widget.textclock,
	},
	layout = wibox.layout.fixed.horizontal,
})

local function tray(name)
	return wibox.widget({
		{
			{
				id = "name",
				markup = helpers:color_markup(name, beautiful.xcolor8),
				font = beautiful.vont .. "Aile Oblique Heavy 10",
				halign = "left",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			margins = { right = dpi(5) },
			layout = wibox.container.margin,
		},
		{
			id = "value",
			markup = "100",
			font = beautiful.vont .. "Aile Oblique Heavy 10",
			halign = "left",
			valign = "center",
			-- forced_width = dpi(30),
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.horizontal,
	})
end

-- Bluetooth Widget
local bluetooth = tray("BLU:")

awesome.connect_signal("bluetooth::status", function(is_powerd)
	bluetooth:get_children_by_id("value")[1]:set_markup(is_powerd and "On" or "Off")
end)

-- Battery Widget
local battery = tray("BAT:")

local indicator = wibox.widget({
	image = helpers:recolor("lighting.png"),
	valign = "center",
	halign = "center",
	forced_width = dpi(10),
	forced_height = dpi(10),
	widget = wibox.widget.imagebox,
})

awesome.connect_signal("battery::info", function(capacity, status)
	battery:get_children_by_id("value")[1]:set_markup(capacity)
	if status == "Charging" then
		indicator:set_image(helpers:recolor("lighting.png"))
	elseif status == "Full" then
		indicator:set_image(helpers:recolor("lighting.png", beautiful.xcolor4))
	elseif status == "Discharging" and capacity <= 20 then
		indicator:set_image(helpers:recolor("lighting.png", beautiful.xcolor1))
	else
		indicator:set_image(helpers:recolor("lighting.png", beautiful.xcolor0))
	end
end)

local menu = wibox.widget({
	image = helpers:recolor("burger.png", beautiful.xcolor8),
	valign = "center",
	halign = "center",
	forced_width = dpi(15),
	forced_height = dpi(15),
	buttons = gears.table.join(awful.button({}, awful.button.names.LEFT, function()
		awesome.emit_signal("shuna::toggle", true)
	end)),
	widget = wibox.widget.imagebox,
})

awesome.connect_signal("shuna::show", function()
	menu:set_image(helpers:recolor("burger.png", beautiful.xcolor4))
end)

awesome.connect_signal("shuna::hide", function()
	menu:set_image(helpers:recolor("burger.png", beautiful.xcolor8))
end)

return {
	clock = clock,
	bluetooth = bluetooth,
	battery = battery,
	indicator = indicator,
	menu = menu,
}

local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local temp = wibox.widget({
	markup = helpers:color_markup("1" .. "<span>&#176;</span>", beautiful.xcolor7),
	font = beautiful.vont .. "Bold 20",
	halign = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local icon = wibox.widget({
	image = helpers:iconify("weather/weather-clear.svg"),
	halign = "center",
	valign = "center",
	forced_height = dpi(35),
	forced_width = dpi(35),
	widget = wibox.widget.imagebox,
})

local country = wibox.widget({
	text = "Die Erde des Gottes",
	font = beautiful.vont .. "11",
	align = "right",
	valign = "center",
	widget = wibox.widget.textbox,
})

local desc = wibox.widget({
	markup = "Cold AF",
	font = beautiful.font,
	align = "right",
	valign = "center",
	widget = wibox.widget.textbox,
})

local humidity = wibox.widget({
	text = "100% Humidity",
	font = beautiful.font,
	valign = "center",
	halign = "center",
	widget = wibox.widget.textbox,
})

awesome.connect_signal("weather::info", function(vtemp, vicon, vdesc, vcountry, vhumidity)
	temp:set_markup(helpers:color_markup(vtemp .. "<span>&#176;</span>", beautiful.xcolor7))
	icon:set_image(vicon)
	country:set_text(vcountry)
	humidity:set_text(vhumidity)
	desc:set_markup(helpers:color_markup(vdesc, beautiful.xforeground))
end)

return wibox.widget({
	{
		{
			{
				{
					temp,
					icon,
					spacing = dpi(5),
					layout = wibox.layout.fixed.horizontal,
				},
				nil,
				{
					country,
					{
						humidity,
						{
							color = beautiful.xcolor4,
							shape = function(cr, w, h)
								gears.shape.circle(cr, w, h)
							end,
							forced_width = dpi(5),
							forced_height = dpi(5),
							widget = wibox.widget.separator,
						},
						desc,
						spacing = dpi(5),
						layout = wibox.layout.fixed.horizontal,
					},
					spacing = dpi(5),
					layout = wibox.layout.fixed.vertical,
				},
				layout = wibox.layout.align.horizontal,
			},
			margins = dpi(10),
			layout = wibox.container.margin,
		},
		shape = helpers:rrect(),
		bg = beautiful.xcolor0,
		forced_height = dpi(60),
		layout = wibox.container.background,
	},
	margins = { left = dpi(10), right = dpi(10), top = dpi(10) },
	layout = wibox.container.margin,
})

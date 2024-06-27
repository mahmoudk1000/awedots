local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local sys_stuff = require("signal.sys")

local noti = require(... .. ".noti")
local info = require(... .. ".info")

local weather_temp = wibox.widget({
	markup = "1" .. "<span>&#176;</span>",
	font = beautiful.vont .. "Bold 26",
	align = "right",
	valign = "center",
	widget = wibox.widget.textbox,
})

local weather_desc = wibox.widget({
	markup = "Cold AF",
	font = beautiful.vont .. "Bold 13",
	align = "right",
	valign = "center",
	widget = wibox.widget.textbox,
})

local weather_land = wibox.widget({
	markup = "Das Land des Gottes",
	font = beautiful.vont .. "11",
	align = "right",
	valign = "center",
	widget = wibox.widget.textbox,
})

awesome.connect_signal("weather::info", function(temp, desc, country)
	weather_temp:set_markup(helpers:color_markup(temp .. "<span>&#176;</span>", beautiful.xforeground))
	weather_desc:set_markup(helpers:color_markup(desc, beautiful.xforeground))
	weather_land:set_markup(helpers:color_markup(country, beautiful.xforeground))
end)

local shuna

local tiktak = gears.timer({
	timeout = 3,
	autostart = true,
	call_now = true,
	callback = function()
		sys_stuff:emit_sys_info()
	end,
})

local function initShuna(s, x)
	if (s.geometry.width - x) <= (beautiful.useless_gap * 2) then
		awesome.emit_signal("shuna::show")
		shuna = awful.popup({
			widget = {
				{
					{
						{
							{
								weather_temp,
								nil,
								{
									weather_land,
									weather_desc,
									layout = wibox.layout.fixed.vertical,
								},
								layout = wibox.layout.align.horizontal,
							},
							margins = dpi(10),
							layout = wibox.container.margin,
						},
						shape = helpers:rrect(),
						bg = beautiful.xcolor0,
						layout = wibox.container.background,
					},
					margins = { left = dpi(10), right = dpi(10), top = dpi(10), bottom = dpi(5) },
					layout = wibox.container.margin,
				},
				noti,
				info,
				layout = wibox.layout.align.vertical,
			},
			ontop = true,
			maximum_width = (20 / 100) * s.geometry.width,
			minimum_height = s.tiling_area.height - (beautiful.useless_gap * 4.4 + beautiful.border_width),
			maximum_height = s.tiling_area.height - (beautiful.useless_gap * 4.4 + beautiful.border_width),
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			shape = helpers:rrect(),
			placement = function(c)
				awful.placement.top_right(c, {
					margins = {
						right = beautiful.useless_gap * 2,
						top = beautiful.useless_gap * 2.2,
						parent = s,
					},
				})
			end,
		})

		shuna:connect_signal("mouse::leave", function()
			shuna.visible = false
			tiktak:stop()
			awesome.emit_signal("shuna::hide")
		end)
	end
end

awesome.connect_signal("shuna::toggle", function(joker)
	if shuna and shuna.visible then
		tiktak:stop()
		shuna.visible = false
		awesome.emit_signal("shuna::hide")
	else
		initShuna(awful.screen.focused(), joker and awful.screen.focused().geometry.width or mouse.coords().x)
		tiktak:start()
	end
end)

root.buttons(gears.table.join(awful.button({}, awful.button.names.LEFT, function()
	awesome.emit_signal("shuna::toggle")
end)))

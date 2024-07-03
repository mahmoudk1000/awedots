local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")

local sys_stuff = require("signal.sys")

local noti = require(... .. ".noti")
local info = require(... .. ".info")
local weather = require(... .. ".weather")

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
				weather,
				noti,
				info,
				layout = wibox.layout.align.vertical,
			},
			ontop = true,
			minimum_width = (20 / 100) * s.geometry.width,
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

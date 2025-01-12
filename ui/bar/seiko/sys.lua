local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("module.rubato")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")
local helpers = require("helpers")
--
-- Clock
local clock = (function()
	local time = wibox.widget({
		{
			format = "%a %d %b, ",
			font = beautiful.font .. "Aile Oblique Heavy 10",
			valign = "center",
			align = "center",
			widget = wibox.widget.textclock,
		},
		{
			format = "%R",
			font = beautiful.font .. "Aile Oblique Heavy 10",
			halign = "center",
			valign = "center",
			widget = wibox.widget.textclock,
		},
		layout = wibox.layout.fixed.horizontal,
	})

	local seconds = wibox.widget({
		font = beautiful.font .. "Aile Oblique Heavy 10",
		halign = "center",
		valign = "center",
		visible = false,
		widget = wibox.widget.textclock(helpers:color_markup(":%S", beautiful.xcolor4), 1),
	})

	local widget = wibox.widget({
		time,
		seconds,
		layout = wibox.layout.fixed.horizontal,
	})

	widget:connect_signal("mouse::enter", function()
		seconds.visible = true
	end)

	widget:connect_signal("mouse::leave", function()
		seconds.visible = false
	end)

	return widget
end)()

local pieTray = function(text, symbol, color)
	local pie = wibox.widget({
		value = 100,
		height = dpi(20),
		background_color = beautiful.xbackground,
		color = color,
		shape = function(cr, w, h)
			gears.shape.arc(cr, w, h, dpi(3), 0, 2 * math.pi)
		end,
		bar_shape = function(cr, w, h)
			gears.shape.arc(cr, w, h, dpi(3), 0, math.rad(100 * 3.6))
		end,
		widget = wibox.widget.progressbar,
	})

	local icon = wibox.widget({
		{
			image = helpers:recolor(symbol, beautiful.xcolor8),
			valign = "center",
			halign = "center",
			opacity = 1,
			widget = wibox.widget.imagebox,
		},
		margins = dpi(5),
		layout = wibox.container.margin,
	})

	local widget = wibox.widget({
		icon,
		{
			pie,
			direction = "east",
			layout = wibox.container.rotate,
		},
		layout = wibox.layout.stack,
	})

	local tooltip = awful.tooltip({
		objects = { widget },
		mode = "outside",
	})

	widget:connect_signal("mouse::enter", function()
		tooltip.markup = "<b>" .. text .. ": </b>" .. pie.value .. "%"
		tooltip:show()
	end)

	widget:connect_signal("mouse::leave", function()
		tooltip:hide()
	end)

	local opacity_animation = rubato.timed({
		duration = 1.0,
		intro = 0.5,
		easing = rubato.easing.quadratic,
		subscribed = function(pos)
			icon.children[1].opacity = pos
		end,
	})

	local opacity_timer = gears.timer({
		timeout = 2.0,
		autostart = false,
		call_now = false,
		callback = function()
			if icon.children[1].opacity == 1 then
				opacity_animation.target = 0
			else
				opacity_animation.target = 1
			end
		end,
	})

	return {
		widget = widget,
		update_value = function(new_value, bat, status)
			if bat then
				if status == "Charging" or status == "Full" then
					if status == "Charging" then
						pie.color = beautiful.xcolor2
						icon.children[1].image = helpers:recolor(symbol, beautiful.xcolor2)
						opacity_timer:start()
					else
						pie.color = beautiful.xcolor5
						icon.children[1].image = helpers:recolor(symbol, beautiful.xcolor5)
						opacity_timer:stop()
						opacity_animation.target = 1
					end
				else
					if new_value <= 20 then
						pie.color = beautiful.xcolor1
						icon.children[1].image = helpers:recolor(symbol, beautiful.xcolor1)
						opacity_animation.target = 1
					else
						pie.color = color
						icon.children[1].image = helpers:recolor(symbol, color)
						opacity_timer:stop()
						opacity_animation.target = 0
					end
				end
			end
			local timed = rubato.timed({
				duration = 0.2,
				pos = math.rad(pie.value * 3.6) / math.rad(new_value * 3.6),
				subscribed = function(pos)
					pie.bar_shape = function(cr, w, h)
						gears.shape.arc(cr, w, h, dpi(3), 0, math.rad(new_value * 3.6 * pos))
					end
				end,
			})
			timed.target = 1
			pie.value = new_value
			tooltip.markup = "<b>" .. text .. ": </b>" .. new_value .. "%"
		end,
	}
end

local function sysTray(icon, color)
	return wibox.widget({
		image = helpers:recolor(icon, color),
		halign = "center",
		valign = "center",
		widget = wibox.widget.imagebox,
	})
end

-- Volume Widget
local volume = pieTray("Vol", icons.tone, beautiful.xcolor3)

awesome.connect_signal("volume::value", function(value, _, _)
	volume.update_value(value, false)
end)

-- Backlight Widget
local backlight = pieTray("Brt", icons.brightness, beautiful.xcolor6)

awesome.connect_signal("brightness::value", function(value)
	backlight.update_value(value, false)
end)

-- Bluetooth Widget
local bluetooth = sysTray(icons.bluetooth.off, beautiful.xcolor4)

awesome.connect_signal("bluetooth::status", function(_, _, icon)
	bluetooth:set_image(helpers:recolor(icon))
end)

-- Battery Widget
local battery = pieTray("Bat", icons.battery.lighting, beautiful.xcolor4)

awesome.connect_signal("battery::info", function(value, status, _)
	battery.update_value(value, true, status)
end)

return {
	clock = clock,
	volume = volume,
	backlight = backlight,
	bluetooth = bluetooth,
	battery = battery,
}

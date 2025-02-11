local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local rubato = require("module.rubato")
local icons = require("icons")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
--
-- Clock
local function create_time_widget()
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
end

local clock = create_time_widget()

local function iconTray(icon)
	local icon_widget = wibox.widget({
		id = "icon",
		image = helpers:recolor(icon),
		halign = "center",
		valign = "center",
		forced_height = dpi(20),
		forced_width = dpi(20),
		widget = wibox.widget.imagebox,
	})

	local text_widget = wibox.widget({
		id = "text",
		text = "Off",
		font = beautiful.vont .. " Aile Oblique Heavy 10",
		ellipsize = "none",
		jusify = true,
		valign = "center",
		visible = false,
		forced_height = dpi(10),
		widget = wibox.widget.textbox,
	})

	local tray_widget = wibox.widget({
		icon_widget,
		text_widget,
		layout = wibox.layout.fixed.horizontal,
	})

	local timed = rubato.timed({
		duration = 1 / 3,
		subscribed = function(pos)
			local w, _ = text_widget:get_preferred_size()
			text_widget.forced_width = dpi(w + 3) * pos
		end,
	})

	tray_widget:connect_signal("mouse::enter", function()
		text_widget.visible = true
		timed.target = 1
	end)

	tray_widget:connect_signal("mouse::leave", function()
		timed.target = 0
		text_widget.visible = false
	end)

	return tray_widget
end

-- Bluetooth Tray
local bluetooth = iconTray(icons.bluetooth.off)

awesome.connect_signal("bluetooth::status", function(is_powered, is_connected, icon)
	bluetooth.children[1]:set_image(helpers:recolor(icon))
	bluetooth.children[2]:set_text(is_powered and (is_connected and "Connected" or "On") or "Off")
end)

-- Wifi Tray
local wifi = iconTray(icons.wifi.off)

awesome.connect_signal("wifi::status", function(_, _, icon, ssid)
	wifi.children[1]:set_image(helpers:recolor(icon))
	wifi.children[2]:set_text(ssid)
end)

local volume = iconTray(icons.volume.mute)

awesome.connect_signal("volume::value", function(percent, icon, is_muted)
	volume.children[1]:set_image(helpers:recolor(icon))
	volume.children[2]:set_text(is_muted and "Muted" or percent .. "%")
end)

-- Battery Widget
local bat = function(value)
	local percent = wibox.widget({
		text = value .. "%",
		font = beautiful.font,
		ellipsize = "none",
		valign = "center",
		halign = "center",
		widget = wibox.widget.textbox,
	})

	local indicator = wibox.widget({
		{
			image = helpers:recolor(icons.battery.nor),
			valign = "center",
			halign = "center",
			widget = wibox.widget.imagebox,
		},
		margins = dpi(5),
		layout = wibox.container.margin,
	})

	local overlay = wibox.widget({
		percent,
		layout = wibox.layout.stack,
	})

	local widget = wibox.widget({
		overlay,
		value = value,
		border_color = beautiful.xcolor8,
		color = beautiful.xcolor4,
		min_value = 0,
		max_value = 100,
		forced_width = dpi(45),
		layout = wibox.container.radialprogressbar,
	})

	local opacity_animation = rubato.timed({
		duration = 1.0,
		intro = 0.5,
		easing = rubato.easing.quadratic,
		subscribed = function(pos)
			indicator.children[1].opacity = pos
		end,
	})

	local opacity_timer = gears.timer({
		timeout = 2.0,
		autostart = false,
		call_now = false,
		callback = function()
			if indicator.children[1].opacity == 1 then
				opacity_animation.target = 0
			else
				opacity_animation.target = 1
			end
		end,
	})

	return {
		widget = widget,
		update = function(capacity, status, _)
			widget.value = capacity

			if status == "Charging" or status == "Full" then
				if status == "Charging" then
					widget.color = beautiful.xcolor3
					indicator.children[1]:set_image(helpers:recolor(icons.battery.lighting_big, beautiful.xcolor3))
					opacity_timer:start()
				else
					widget.color = beautiful.xcolor2
					indicator.children[1]:set_image(helpers:recolor(icons.battery.lighting_big, beautiful.xcolor2))
					opacity_timer:stop()
					opacity_animation.target = 1
				end
				overlay:replace_widget(percent, indicator)
			else
				percent:set_text(capacity .. "%")
				if capacity == 100 then
					widget.color = beautiful.xcolor1
				else
					widget.color = beautiful.xcolor4
				end
				opacity_timer:stop()
				overlay:replace_widget(indicator, percent)
			end
		end,
	}
end

local battery = bat(100)

awesome.connect_signal("battery::info", function(value, status, icon)
	battery.update(value, status, icon)
end)

return {
	clock = clock,
	bluetooth = bluetooth,
	wifi = wifi,
	volume = volume,
	battery = battery,
}

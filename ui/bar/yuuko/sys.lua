local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local rubato = require("module.rubato")
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

	local seconds_text = os.date("%S")
	local seconds = wibox.widget({
		markup = helpers:color_markup(":" .. os.date("%S"), beautiful.xcolor4),
		font = beautiful.font .. "Aile Oblique Heavy 10",
		halign = "center",
		valign = "center",
		visible = false,
		widget = wibox.widget.textbox,
	})

	local widget = wibox.widget({
		time,
		seconds,
		layout = wibox.layout.fixed.horizontal,
	})

	gears.timer({
		timeout = 1,
		call_now = true,
		autostart = true,
		callback = function()
			seconds_text = tonumber(seconds_text) + 1
			if seconds_text >= 60 then
				seconds_text = 0
			end
			seconds.markup = helpers:color_markup(":" .. string.format("%02d", seconds_text), beautiful.xcolor4)
		end,
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

local function iconTray(icon, color)
	local icon_widget = wibox.widget({
		id = "icon",
		image = helpers:recolor(icon, color),
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
local bluetooth = iconTray("blue-on.png", beautiful.xcolor4)

awesome.connect_signal("bluetooth::status", function(is_powered, is_connected, icon)
	bluetooth.children[1]:set_image(helpers:recolor(icon))
	bluetooth.children[2]:set_text(is_powered and (is_connected and "Connected" or "On") or "Off")
	bluetooth:emit_signal("widget::layout_changed")
end)

-- Wifi Tray
local wifi = iconTray("wifi.png", beautiful.xcolor4)

awesome.connect_signal("wifi::status", function(_, _, icon, ssid)
	wifi.children[1]:set_image(helpers:recolor(icon))
	wifi.children[2]:set_text(ssid)
	bluetooth:emit_signal("widget::layout_changed")
end)

local volume = iconTray("volume_01.png", beautiful.xcolor4)

awesome.connect_signal("volume::value", function(percent, icon, is_muted)
	volume.children[1]:set_image(helpers:recolor(icon))
	volume.children[2]:set_text(is_muted and "Muted" or percent .. "%")
	volume:emit_signal("widget::layout_changed")
end)

-- Battery Widget
local bat = function(value, icon)
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
			image = helpers:recolor(icon),
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

	local opacity_animation = rubato.timed {
		duration = 1.0,
		intro = 0.5,
		easing = rubato.easing.quadratic,
		subscribed = function(pos)
			indicator.children[1].opacity = pos
		end,
	}

	local opacity_timer = gears.timer {
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
	}

	return {
		widget = widget,
		update = function(capacity, status, _)
			widget.value = capacity

			if status == "Charging" or status == "Full" then
				if status == "Charging" then
					widget.color = beautiful.xcolor3
					indicator.children[1]:set_image(helpers:recolor("indicator.png", beautiful.xcolor3))
					opacity_timer:start()
				else
					widget.color = beautiful.xcolor2
					indicator.children[1]:set_image(helpers:recolor("indicator.png", beautiful.xcolor2))
					opacity_timer:stop()
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

local battery = bat(100, "indicator.png")

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

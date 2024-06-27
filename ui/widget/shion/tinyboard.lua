local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local backlight_stuff = require("signal.backlight")
local bluetooth_stuff = require("signal.bluetooth")
local redshift_stuff = require("signal.redshift")
local volume_stuff = require("signal.volume")
local wifi_stuff = require("signal.wifi")

local make_button = function(text, icon)
	return wibox.widget({
		{
			{
				{
					{
						{
							{
								id = "circle",
								bg = beautiful.xcolor8,
								shape = gears.shape.circle,
								widget = wibox.container.background,
							},
							{
								{
									id = "icon",
									image = helpers:recolor(icon),
									valign = "center",
									halign = "center",
									forced_height = dpi(20),
									forced_width = dpi(20),
									widget = wibox.widget.imagebox,
								},
								margins = dpi(5),
								layout = wibox.container.margin,
							},
							layout = wibox.layout.stack,
						},
						margins = { right = dpi(10) },
						layout = wibox.container.margin,
					},
					{
						id = "text",
						text = text,
						align = "left",
						ellipsize = "none",
						font = beautiful.font,
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.align.horizontal,
				},
				margins = dpi(10),
				layout = wibox.container.margin,
			},
			halign = "left",
			valign = "center",
			widget = wibox.container.place,
		},
		bg = beautiful.xcolor0,
		widget = wibox.container.background,
		shape = helpers:rrect(),
	})
end

-- Wifi Button
local wifi_button = make_button("Wifi", "wifi.png")

wifi_button.buttons = {
	awful.button({}, awful.button.names.LEFT, function()
		awful.spawn.easy_async_with_shell("iwctl device list | awk '/on/{print $4}'", function(stdout)
			local toggle_command = (stdout:match("on")) and "rfkill block wlan" or "rfkill unblock wlan"
			awful.spawn.easy_async(toggle_command, function()
				wifi_stuff:emit_wifi_info()
			end)
		end)
	end),
}

awesome.connect_signal("wifi::info", function(is_powerd, is_connected, wifi_name)
	if is_powerd or (is_powerd and is_connected) then
		wifi_button.bg = beautiful.xcolor8
		wifi_button:get_children_by_id("circle")[1].bg = beautiful.xcolor4
		wifi_button:get_children_by_id("text")[1]:set_text(wifi_name)
		wifi_button:get_children_by_id("icon")[1]:set_image(helpers:recolor("wifi.png", beautiful.xcolor0))
	else
		wifi_button.bg = beautiful.xcolor0
		wifi_button:get_children_by_id("circle")[1].bg = beautiful.xcolor8
		wifi_button:get_children_by_id("text")[1]:set_text(wifi_name)
		wifi_button:get_children_by_id("icon")[1]:set_image(helpers:recolor("wifi.png"))
	end
end)

-- Bluetooth Button
local bluetooth_button = make_button("Bluetooth", "blue-off.png")

bluetooth_button.buttons = {
	awful.button({}, awful.button.names.LEFT, function()
		awful.spawn.easy_async_with_shell("bluetoothctl show | grep -q 'Powered: yes'", function(_, _, _, exitcode)
			local toggle_command = (exitcode == 0) and "bluetoothctl power off" or "bluetoothctl power on"
			awful.spawn.easy_async(toggle_command, function()
				bluetooth_stuff:emit_bluetooth_info()
			end)
		end)
	end),
}

awesome.connect_signal("bluetooth::status", function(is_powerd, _, icon)
	if is_powerd then
		bluetooth_button.bg = beautiful.xcolor8
		bluetooth_button:get_children_by_id("circle")[1].bg = beautiful.xcolor4
		bluetooth_button:get_children_by_id("icon")[1]:set_image(helpers:recolor(icon, beautiful.xcolor0))
	else
		bluetooth_button.bg = beautiful.xcolor0
		bluetooth_button:get_children_by_id("circle")[1].bg = beautiful.xcolor8
		bluetooth_button:get_children_by_id("icon")[1]:set_image(helpers:recolor(icon))
	end
end)

-- Redshift Button
local redshift_button = make_button("Redshift", "redshift.png")

redshift_button.buttons = {
	awful.button({}, awful.button.names.LEFT, function()
		awful.spawn.easy_async("systemctl --user is-active --quiet redshift.service", function(_, _, _, exitcode)
			local toggle_command = (exitcode == 0) and "systemctl --user stop redshift.service"
				or "systemctl --user start redshift.service"
			awful.spawn.easy_async(toggle_command, function()
				redshift_stuff:emit_redshift_info()
			end)
		end)
	end),
}

awesome.connect_signal("redshift::state", function(state)
	if state == "On" then
		redshift_button.bg = beautiful.xcolor8
		redshift_button:get_children_by_id("circle")[1].bg = beautiful.xcolor4
		redshift_button:get_children_by_id("icon")[1]:set_image(helpers:recolor("redshift.png", beautiful.xcolor0))
	else
		redshift_button.bg = beautiful.xcolor0
		redshift_button:get_children_by_id("circle")[1].bg = beautiful.xcolor8
		redshift_button:get_children_by_id("icon")[1]:set_image(helpers:recolor("redshift.png"))
	end
end)

-- Mic Button
local mic_button = make_button("Mic", "mic.png")

mic_button.buttons = {
	awful.button({}, awful.button.names.LEFT, function()
		awful.spawn.easy_async("amixer sget Capture", function(stdout)
			local muted = stdout:match("%[off%]")
			if muted then
				awful.spawn({ "amixer", "set", "Capture", "cap" })
			else
				awful.spawn({ "amixer", "set", "Capture", "nocap" })
			end
			volume_stuff:emit_mic_state()
		end)
	end),
}

awesome.connect_signal("mic::status", function(is_muted)
	if is_muted then
		mic_button.bg = beautiful.xcolor0
		mic_button:get_children_by_id("circle")[1].bg = beautiful.xcolor8
		mic_button:get_children_by_id("icon")[1]:set_image(helpers:recolor("mic.png"))
	else
		mic_button.bg = beautiful.xcolor8
		mic_button:get_children_by_id("circle")[1].bg = beautiful.xcolor4
		mic_button:get_children_by_id("icon")[1]:set_image(helpers:recolor("mic.png", beautiful.xcolor0))
	end
end)

local make_slider = function(text, icon)
	return wibox.widget({
		{
			{
				image = helpers:recolor(icon),
				valign = "center",
				halign = "cneter",
				forced_width = dpi(30),
				forced_height = dpi(30),
				widget = wibox.widget.imagebox,
			},
			margins = { right = dpi(10) },
			layout = wibox.container.margin,
		},
		{
			{
				markup = "<b>" .. text .. "</b>",
				font = beautiful.font_bold,
				widget = wibox.widget.textbox,
			},
			{
				id = "slider",
				value = 100,
				handle_border_color = beautiful.xcolor0,
				handle_border_width = dpi(5),
				handle_color = beautiful.xcolor4,
				handle_width = dpi(10),
				handle_shape = helpers:rrect(),
				bar_active_color = beautiful.xcolor4,
				bar_color = beautiful.xcolor8,
				bar_height = dpi(15),
				bar_shape = helpers:rrect(10),
				widget = wibox.widget.slider,
			},
			layout = wibox.layout.flex.vertical,
		},
		layout = wibox.layout.align.horizontal,
	})
end

-- Backlight Progress
local backlight_progress = make_slider("Brightness", "lamp.png")

backlight_progress:get_children_by_id("slider")[1]:connect_signal("property::value", function(_, new_value)
	awful.spawn.easy_async("brightnessctl set " .. new_value .. "%", function()
		backlight_stuff:emit_backlight_info()
	end)
end)

awesome.connect_signal("brightness::value", function(value)
	backlight_progress:get_children_by_id("slider")[1]:set_value(value)
end)

-- Volume Progress
local volume_progress = make_slider("Volume", "sound.png")

volume_progress:get_children_by_id("slider")[1]:connect_signal("property::value", function(_, new_value)
	awful.spawn.easy_async("pamixer --set-volume " .. new_value, function()
		volume_stuff:emit_volume_state()
	end)
end)

awesome.connect_signal("volume::value", function(value)
	volume_progress:get_children_by_id("slider")[1]:set_value(value)
end)

return {
	toggles = {
		{
			wifi_button,
			bluetooth_button,
			redshift_button,
			mic_button,
			spacing = dpi(10),
			forced_num_cols = 4,
			forced_num_rows = 1,
			expand = true,
			homogeneous = true,
			layout = wibox.layout.grid,
		},
		forced_height = dpi(70),
		margins = dpi(5),
		layout = wibox.container.margin,
	},
	sliders = {
		{
			{
				{
					volume_progress,
					backlight_progress,
					spacing = dpi(10),
					layout = wibox.layout.flex.vertical,
				},
				margins = dpi(10),
				layout = wibox.container.margin,
			},
			bg = beautiful.xcolor0,
			shape = helpers:rrect(),
			layout = wibox.container.background,
		},
		margins = dpi(5),
		layout = wibox.container.margin,
	},
}

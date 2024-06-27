local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local ruled = require("ruled")
local beautiful = require("beautiful")

local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- Notification Default Config
naughty.config.defaults = {
	title = "Notification",
	position = "top_right",
	border_width = beautiful.notification_border_width,
}

-- Ruled Notification Types
ruled.notification.connect_signal("request::rules", function()
	-- Global
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 6,
		},
	})
	-- Critical
	ruled.notification.append_rule({
		rule = {
			urgency = "critical",
		},
		properties = {
			bg = beautiful.bg_normal,
			fg = beautiful.fg_urgent,
			timeout = 0,
		},
	})

	-- Normal
	ruled.notification.append_rule({
		rule = { urgency = "normal" },
		properties = {
			bg = beautiful.bg_normal,
			fg = beautiful.fg_normal,
			timeout = 5,
		},
	})

	-- Low
	ruled.notification.append_rule({
		rule = {
			urgency = "low",
		},
		properties = {
			bg = beautiful.bg_normal,
			fg = beautiful.fg_normal,
			timeout = 3,
		},
	})
end)

-- Notification Rules
naughty.connect_signal("request::display", function(n)
	naughty.layout.box({
		notification = n,
		type = "notification",
		bg = beautiful.xbackground,
		widget_template = {
			{
				{
					{
						{
							{
								{
									{
										naughty.widget.title,
										forced_height = dpi(30),
										layout = wibox.layout.align.horizontal,
									},
									margins = { left = dpi(10), right = dpi(10) },
									layout = wibox.container.margin,
								},
								shape = helpers:rrect(beautiful.border_radius / 2),
								bg = beautiful.bg_focus,
								layout = wibox.container.background,
							},
							strategy = "min",
							width = dpi(300),
							layout = wibox.container.constraint,
						},
						strategy = "max",
						width = dpi(400),
						layout = wibox.container.constraint,
					},
					{
						{
							{
								naughty.widget.message,
								margins = dpi(15),
								layout = wibox.container.margin,
							},
							strategy = "min",
							height = dpi(60),
							layout = wibox.container.constraint,
						},
						strategy = "max",
						width = dpi(400),
						layout = wibox.container.constraint,
					},
					layout = wibox.layout.align.vertical,
				},
				color = beautiful.xbackground,
				margins = { left = dpi(10), right = dpi(10), top = dpi(12) },
				layout = wibox.container.margin,
			},
			id = "background_role",
			layout = naughty.container.background,
		},
	})
end)

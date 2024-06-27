local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local notifications = {}

local function notification_widget(n)
	local n_title = wibox.widget({
		markup = n.title,
		font = beautiful.vont .. "Bold 10",
		align = "left",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local n_text = wibox.widget({
		markup = n.message,
		align = "left",
		valign = "center",
		forced_height = dpi(15),
		widget = wibox.widget.textbox,
	})

	return wibox.widget({
		{
			{
				{
					{
						{
							n_title,
							margins = { bottom = dpi(4) },
							layout = wibox.container.margin,
						},
						n_text,
						layout = wibox.layout.flex.vertical,
					},
					margins = dpi(10),
					widget = wibox.container.margin,
				},
				shape = helpers:rrect(),
				bg = beautiful.xcolor8,
				widget = wibox.container.background,
			},
			margins = { left = dpi(10), right = dpi(10) },
			layout = wibox.container.margin,
		},
		spacing = dpi(5),
		forced_height = dpi(60),
		layout = wibox.layout.fixed.vertical,
	})
end

local function create_notification_container(noties)
	if #noties == 0 then
		return wibox.widget({
			{
				markup = helpers:color_markup("Nothing", beautiful.xcolor8),
				font = beautiful.vont .. "Bold 14",
				align = "center",
				valign = "center",
				widget = wibox.widget.textbox,
			},
			shape = helpers:rrect(),
			bg = beautiful.xcolor0,
			layout = wibox.container.background,
		})
	end

	local notification_layout = wibox.layout.fixed.vertical()

	for i = #notifications, 1, -1 do
		notification_layout:add(notifications[i])
	end

	return wibox.widget({
		{
			notification_layout,
			layout = wibox.layout.align.vertical,
		},
		shape = helpers:rrect(),
		bg = beautiful.xcolor0,
		layout = wibox.container.background,
	})
end

local notification_container = create_notification_container(notifications)

naughty.connect_signal("request::display", function(n)
	table.insert(notifications, notification_widget(n))

	if #notifications >= 13 then
		table.remove(notifications, 1)
	end

	notification_container:set_widget(create_notification_container(notifications))
end)

local title = wibox.widget({
	text = "Notifications",
	font = beautiful.font_bold,
	valign = "center",
	halign = "center",
	widget = wibox.widget.textbox,
})

local clearAll = wibox.widget({
	{
		{
			markup = helpers:color_markup("Clear all", beautiful.xcolor1),
			align = "center",
			valign = "center",
			buttons = awful.button({}, awful.button.names.LEFT, function()
				notifications = {}
				notification_container:set_widget(create_notification_container(notifications))
			end),
			widget = wibox.widget.textbox,
		},
		margins = { left = dpi(10), right = dpi(10) },
		layout = wibox.container.margin,
	},
	bg = beautiful.xcolor1 .. "4D",
	shape = helpers:rrect(beautiful.border_radius / 2),
	layout = wibox.container.background,
})

return wibox.widget({
	{
		{
			{
				{
					title,
					nil,
					clearAll,
					forced_height = dpi(25),
					layout = wibox.layout.align.horizontal,
				},
				margins = dpi(15),
				layout = wibox.container.margin,
			},
			notification_container,
			layout = wibox.layout.align.vertical,
		},
		shape = helpers:rrect(),
		bg = beautiful.xcolor0,
		layout = wibox.container.background,
	},
	margins = { left = dpi(10), right = dpi(10), top = dpi(5), bottom = dpi(5) },
	layout = wibox.container.margin,
})

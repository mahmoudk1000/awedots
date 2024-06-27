local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local dateWidget = function(date, weekend, notIn)
	weekend = weekend or false

	if notIn then
		return wibox.widget({
			markup = helpers:color_markup(date, beautiful.xcolor8),
			halign = "center",
			widget = wibox.widget.textbox,
		})
	else
		return wibox.widget({
			markup = weekend and helpers:color_markup(date, beautiful.xforeground) or date,
			halign = "center",
			widget = wibox.widget.textbox,
		})
	end
end

local dayWidget = function(day, weekend)
	weekend = weekend or false

	return wibox.widget({
		markup = weekend and helpers:color_markup(day, beautiful.xcolor6) or day,
		font = beautiful.font_bold,
		halign = "center",
		widget = wibox.widget.textbox,
	})
end

local todayWidget = function(day)
	return wibox.widget({
		{
			markup = helpers:color_markup(day, beautiful.xcolor4),
			halign = "center",
			widget = wibox.widget.textbox,
		},
		bg = beautiful.xcolor4 .. "50",
		shape = helpers:rrect(),
		layout = wibox.container.background,
	})
end

local header = wibox.widget({
	font = beautiful.vont .. "Bold 12",
	halign = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local monthView = wibox.widget({
	column_count = 7,
	row_count = 7,
	expand = true,
	homogenous = true,
	layout = wibox.layout.grid,
})

local current

local updateCalendar = function(date)
	header.text = os.date("%B, %Y", os.time(date))
	monthView:reset()

	for _, w in ipairs({ "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }) do
		if w == "Fri" or w == "Sat" then
			monthView:add(dayWidget(w, true))
		else
			monthView:add(dayWidget(w, false))
		end
	end

	local firstDate = os.date("*t", os.time({ day = 1, month = date.month, year = date.year }))
	local lastDate = os.date("*t", os.time({ day = 0, month = date.month + 1, year = date.year }))
	local days_to_add_at_month_start = firstDate.wday - 1
	local days_to_add_at_month_end = 42 - lastDate.day - days_to_add_at_month_start

	local previous_month_last_day = os.date("*t", os.time({ year = date.year, month = date.month, day = 0 })).day
	local row = 2
	local col = firstDate.wday

	for day = previous_month_last_day - days_to_add_at_month_start, previous_month_last_day - 1, 1 do
		monthView:add(dateWidget(day, false, true))
	end

	local actualDate = os.date("*t")

	for day = 1, lastDate.day do
		if day == date.day and date.month == actualDate.month and date.year == actualDate.year then
			monthView:add_widget_at(todayWidget(day), row, col)
		elseif col == 1 or col == 7 then
			monthView:add_widget_at(dateWidget(day, true, false), row, col)
		else
			monthView:add_widget_at(dateWidget(day, false, false), row, col)
		end

		if col == 7 then
			col = 1
			row = row + 1
		else
			col = col + 1
		end
	end

	for day = 1, days_to_add_at_month_end do
		monthView:add(dateWidget(day, false, true))
	end
end

header.buttons = awful.button({}, awful.button.names.LEFT, function()
	current = os.date("*t")
	updateCalendar(current)
end)

return function()
	current = os.date("*t")
	updateCalendar(current)

	gears.timer({
		timeout = 60,
		call_now = true,
		autostart = true,
		callback = function()
			current = os.date("*t")
			updateCalendar(current)
		end,
	})

	return wibox.widget({
		{
			{
				{
					{
						{
							{
								{
									text = "󰁍",
									font = beautiful.font,
									widget = wibox.widget.textbox,
								},
								margins = { left = dpi(10), right = dpi(10), top = dpi(7), bottom = dpi(7) },
								layout = wibox.container.margin,
							},
							bg = beautiful.xcolor8,
							shape = helpers:rrect(),
							buttons = awful.button({}, awful.button.names.LEFT, function()
								current = os.date(
									"*t",
									os.time({
										day = current.day,
										month = current.month - 1,
										year = current.year,
									})
								)
								updateCalendar(current)
							end),
							layout = wibox.container.background,
						},
						header,
						{
							{
								{
									text = "󰁔",
									font = beautiful.font,
									widget = wibox.widget.textbox,
								},
								margins = { left = dpi(10), right = dpi(10), top = dpi(7), bottom = dpi(7) },
								layout = wibox.container.margin,
							},
							bg = beautiful.xcolor8,
							shape = helpers:rrect(),
							buttons = awful.button({}, awful.button.names.LEFT, function()
								current = os.date(
									"*t",
									os.time({
										day = current.day,
										month = current.month + 1,
										year = current.year,
									})
								)
								updateCalendar(current)
							end),
							layout = wibox.container.background,
						},
						layout = wibox.layout.align.horizontal,
					},
					monthView,
					layout = wibox.layout.align.vertical,
				},
				margins = dpi(10),
				widget = wibox.container.margin,
			},
			bg = beautiful.xcolor0,
			shape = helpers:rrect(),
			widget = wibox.container.background,
		},
		margins = dpi(5),
		layout = wibox.container.margin,
	})
end

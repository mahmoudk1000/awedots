local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local makeButton = function(icon, color, action)
	return wibox.widget({
		{
			{
				id = "icon",
				image = helpers:recolor(icon, color),
				resize = true,
				widget = wibox.widget.imagebox,
			},
			margins = { top = dpi(3), bottom = dpi(3) },
			layout = wibox.container.margin,
		},
		buttons = gears.table.join(awful.button({}, awful.button.names.LEFT, action)),
		widget = wibox.container.background,
	})
end

client.connect_signal("request::titlebars", function(c)
	local titlebar = awful.titlebar(c, {
		position = "top",
		size = dpi(25),
	})

	local buttons = {
		awful.button({}, awful.button.names.LEFT, function()
			c:activate({ context = "titlebar", action = "mouse_move" })
		end),
		awful.button({}, awful.button.names.RIGHT, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	}

	local close = makeButton("close.png", beautiful.xcolor1, function()
		c:kill()
	end)

	local maximize = makeButton("max.png", beautiful.xcolor2, function()
		c.maximized = not c.maximized
		c:raise()
	end)

	c:connect_signal("property::maximized", function()
		local icon = c.maximized and "unmax.png" or "max.png"
		maximize:get_children_by_id("icon")[1].image = helpers:recolor(icon, beautiful.xcolor2)
	end)

	local minimize = makeButton("min.png", beautiful.xcolor3, function()
		c.minimized = true
	end)

	local separator = wibox.widget({
		color = c.active and beautiful.border_focus or beautiful.border_normal,
		thickness = beautiful.border_width,
		forced_height = beautiful.border_width,
		forced_width = c.width,
		widget = wibox.widget.separator,
	})

	titlebar:setup({
		nil,
		{
			{
				{
					awful.titlebar.widget.titlewidget(c),
					buttons = buttons,
					layout = wibox.layout.fixed.horizontal,
				},
				{
					nil,
					buttons = buttons,
					layout = wibox.layout.flex.horizontal,
				},
				{
					minimize,
					maximize,
					close,
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.align.horizontal,
			},
			margins = { top = dpi(2.5), bottom = dpi(2.5), left = dpi(10), right = dpi(10) },
			layout = wibox.container.margin,
		},
		separator,
		layout = wibox.layout.align.vertical,
	})

	c:connect_signal("focus", function()
		separator.color = beautiful.border_focus
	end)

	c:connect_signal("unfocus", function()
		separator.color = beautiful.border_normal
	end)
end)

client.connect_signal("request::manage", function(c)
	if awful.layout.get(c.screen) == awful.layout.suit.floating then
		awful.titlebar.show(c)
	end
end)

tag.connect_signal("property::layout", function(t)
	for _, c in ipairs(t:clients()) do
		if awful.layout.get(t.screen) == awful.layout.suit.floating then
			awful.titlebar.show(c)
		else
			awful.titlebar.hide(c)
		end
	end
end)

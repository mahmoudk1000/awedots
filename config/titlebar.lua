local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local recolor = gears.color.recolor_image
local res_path = gears.filesystem.get_configuration_dir() .. "theme/res/"

local makeButton = function(icon, color, action)
	return wibox.widget({
		{
			{
				image = recolor(res_path .. icon, color),
				resize = true,
				widget = wibox.widget.imagebox,
			},
			margins = { top = dpi(3), bottom = dpi(3), left = dpi(0), right = dpi(0) },
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

	local close = makeButton("close.png", beautiful.xcolor1, function()
		c:kill()
	end)

	local maximize = makeButton("max.png", beautiful.xcolor2, function()
		c.maximized = not c.maximized
		c:raise()
	end)

	c:connect_signal("property::maximized", function()
		local icon = c.maximized and "unmax.png" or "max.png"
		maximize.children[1].children[1].image = recolor(res_path .. icon, beautiful.xcolor2)
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
				awful.titlebar.widget.titlewidget(c),
				nil,
				{
					minimize,
					maximize,
					close,
					spacing = dpi(7),
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

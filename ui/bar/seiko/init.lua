local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- Modules
local taglist = require(... .. ".taglist")
local layoutbox = require(... .. ".layoutbox")
local sys = require(... .. ".sys")

-- Bar
local function init_bar(s)
	local bar = awful.wibar({
		screen = s,
		position = "bottom",
		type = "dock",
		ontop = false,
		height = beautiful.bar_height,
		width = s.geometry.width,
	})

	bar:struts({ bottom = bar.height })

	bar:setup({
		{
			{
				{
					-- Left Widgets
					{
						{
							layoutbox(s),
							margins = dpi(7),
							layout = wibox.container.margin,
						},
						bg = beautiful.xcolor0,
						shape = helpers:rrect(6),
						layout = wibox.container.background,
					},
					{
						{
							taglist(s),
							margins = dpi(12),
							layout = wibox.container.margin,
						},
						bg = beautiful.xcolor0,
						shape = helpers:rrect(6),
						layout = wibox.container.background,
					},
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
				nil,
				{
					-- Right Widgets
					{
						{
							sys.bluetooth,
							sys.backlight,
							sys.volume,
							{
								color = beautiful.xcolor8,
								shape = gears.shape.line,
								thickness = dpi(1),
								forced_width = dpi(1),
								widget = wibox.widget.separator,
							},
							sys.battery,
							spacing = dpi(10),
							layout = wibox.layout.fixed.horizontal,
						},
						margins = { left = dpi(10), right = dpi(10), top = dpi(5), bottom = dpi(5) },
						layout = wibox.container.margin,
					},
					bg = beautiful.xcolor0,
					shape = helpers:rrect(6),
					layout = wibox.container.background,
				},
				layout = wibox.layout.align.horizontal,
			},
			{
				-- Middle Widget
				sys.clock,
				layout = wibox.container.place,
			},
			layout = wibox.layout.stack,
		},
		forced_height = bar.height,
		margins = { left = dpi(10), right = dpi(10), top = dpi(7), bottom = dpi(5) },
		layout = wibox.container.margin,
	})

	bar.buttons = gears.table.join(awful.button({}, awful.button.names.RIGHT, function()
		awesome.emit_signal("shion::toggle")
	end))

	client.connect_signal("swapped", function(c)
		if c.fullscreen or c.maximized then
			bar.visible = false
		else
			bar.visible = true
		end
	end)
end

awful.screen.connect_for_each_screen(function(s)
	s.init_bar = init_bar(s)
end)

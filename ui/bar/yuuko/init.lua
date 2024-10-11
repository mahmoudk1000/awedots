local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- Modules
local layoutbox = require(... .. ".layoutbox")
local taglist = require(... .. ".taglist")
local sys = require(... .. ".sys")

-- Bar
local function init_bar(s)
	local bar = awful.wibar({
		screen = s,
		position = "bottom",
		type = "dock",
		ontop = false,
		bg = beautiful.xcolor0,
		height = beautiful.bar_height,
		width = s.geometry.width,
	})

	bar:struts({ bottom = bar.height })

	bar:setup({
		{
			-- Left Widgets
			{
				{
					sys.clock,
					margins = {
						left = dpi(10),
						right = dpi(10),
						top = dpi(bar.height / 3.5),
						bottom = dpi(bar.height / 3.5),
					},
					layout = wibox.container.margin,
				},
				bg = beautiful.xcolor8,
				layout = wibox.container.background,
			},
			{
				{
					taglist(s),
					margins = {
						left = dpi(10),
						right = dpi(10),
						top = dpi(bar.height / 3.5),
						bottom = dpi(bar.height / 3.5),
					},
					layout = wibox.container.margin,
				},
				bg = beautiful.xbackground,
				layout = wibox.container.background,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		nil,
		{
			-- Right Widgets
			{
				{
					{
						sys.wifi,
						sys.volume,
						sys.bluetooth,
						spacing = dpi(10),
						layout = wibox.layout.fixed.horizontal,
					},
					margins = {
						left = dpi(10),
						right = dpi(10),
						top = dpi(bar.height / 3.5),
						bottom = dpi(bar.height / 3.5),
					},
					layout = wibox.container.margin,
				},
				bg = beautiful.xbackground,
				layout = wibox.container.background,
			},
			{
				{
					{
						sys.battery,
						margins = {
							left = dpi(10),
							right = dpi(0),
							top = dpi(bar.height / 4.5),
							bottom = dpi(bar.height / 4.5),
						},
						layout = wibox.container.margin,
					},
					{
						layoutbox(s),
						margins = {
							left = dpi(0),
							right = dpi(10),
							top = dpi(bar.height / 3.5),
							bottom = dpi(bar.height / 3.5),
						},
						layout = wibox.container.margin,
					},
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
				bg = beautiful.xcolor8,
				layout = wibox.container.background,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		layout = wibox.layout.align.horizontal,
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

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

-- Modules
local taglist = require(... .. ".taglist")
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
				-- Left Widgets
				sys.clock,
				{
					taglist(s),
					margins = { top = dpi(3), bottom = dpi(3) },
					layout = wibox.container.margin,
				},
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
			},
			nil,
			{
				-- Right Widgets
				sys.bluetooth,
				{
					sys.battery,
					sys.indicator,
					spacing = dpi(3),
					layout = wibox.layout.fixed.horizontal,
				},
				sys.menu,
				spacing = dpi(10),
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		margins = { left = dpi(10), right = dpi(10) },
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

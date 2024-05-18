local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

-- Modules
local taglist = require(... .. ".taglist")
local tasklist = require(... .. ".tasklist")
local layoutbox = require(... .. ".layoutbox")
local sys = require(... .. ".sys")

-- Bar
local function init_bar(s)
	local bar = awful.wibar({
		screen = s,
		position = "bottom",
		type = "dock",
		ontop = false,
		height = dpi(30),
		width = s.geometry.width,
	})

	bar:struts({ bottom = bar.height })

	bar:setup({
		{
			{
				{
					-- Left Widgets
					layoutbox(s),
					{
						taglist(s),
						margins = { top = dpi(3), bottom = dpi(3) },
						layout = wibox.container.margin,
					},
					tasklist(s),
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
				nil,
				{
					-- Right Widgets
					sys.volume,
					sys.backlight,
					sys.bluetooth,
					sys.battery,
					spacing = dpi(10),
					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.align.horizontal,
			},
			{
				-- Middle Widget
				sys.clock,
				haligh = "center",
				valign = "center",
				layout = wibox.container.place,
			},
			layout = wibox.layout.stack,
		},
		forced_height = bar.height,
		margins = { left = dpi(10), right = dpi(10), top = dpi(9), bottom = dpi(7) },
		layout = wibox.container.margin,
	})

	client.connect_signal("focus", function(c)
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

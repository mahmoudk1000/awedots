local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")

-- Wallpaper
awful.screen.connect_for_each_screen(function(s)
	if gfs.file_readable(beautiful.wallpaper) then
		local wallpaper = beautiful.wallpaper

		if type(beautiful.wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, false, nil)
	else
		awful.wallpaper({
			screen = s,
			widget = wibox.widget({
				{
					markup = "[WALLPAPER FAILURE]",
					font = beautiful.vont .. "Bold 22",
					valign = "center",
					halign = "center",
					widget = wibox.widget.textbox,
				},
				fg = beautiful.xbackground,
				bg = {
					type = "linear",
					from = { 0, 0 },
					to = { 0, 1080 },
					stops = {
						{ 0, beautiful.xcolor4 },
						{ 1, beautiful.xcolor8 },
					},
				},
				layout = wibox.container.background,
			}),
		})
	end
end)

screen.connect_signal("arrange", function(s)
	local only_one = #s.tiled_clients == 1
	for _, c in pairs(s.clients) do
		if only_one and not c.floating or c.maximized or c.fullscreen then
			c.border_width = 0
		else
			c.border_width = beautiful.border_width
		end
	end
end)

-- Window Bordering
client.connect_signal("manage", function(c)
	c.border_color = beautiful.border_focus

	c:connect_signal("focus", function()
		c.border_color = beautiful.border_focus
	end)

	c:connect_signal("unfocus", function()
		c.border_color = beautiful.border_normal
	end)

	c:connect_signal("marked", function()
		c.border_color = beautiful.border_marked
	end)
end)

client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local taglist = function(s)
	local modkey = "Mod4"
	local buttons = awful.util.table.join(
		awful.button({}, awful.button.names.LEFT, function(t)
			t:view_only()
		end),
		awful.button({ modkey }, awful.button.names.LEFT, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, awful.button.names.RIGHT, awful.tag.viewtoggle),
		awful.button({ modkey }, awful.button.names.RIGHT, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, awful.button.names.SCROLL_UP, function(t)
			awful.tag.viewprev(t.screen)
		end),
		awful.button({}, awful.button.names.SCROLL_DOWN, function(t)
			awful.tag.viewnext(t.screen)
		end)
	)

	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = wibox.layout.fixed.horizontal,
		style = {
			shape = gears.shape.rounded_bar,
		},
		widget_template = {
			{
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
		buttons = buttons,
	})
end

return taglist

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local rubato = require("mods.rubato")

local dpi = beautiful.xresources.apply_dpi

local taglist = function(s)
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
		style = {
			shape = gears.shape.rounded_bar,
		},
		layout = {
			spacing = dpi(7),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			id = "background_role",
			widget = wibox.container.background,
			create_callback = function(self, t, _)
				self.animator = rubato.timed({
					duration = 0.2,
					subscribed = function(pos)
						self:get_children_by_id("background_role")[1].forced_width = pos
					end,
				})

				self.update = function()
					if t.selected then
						self.animator.target = dpi(20)
					elseif #t:clients() == 0 then
						self.animator.target = dpi(10)
					else
						self.animator.target = dpi(15)
					end
				end

				self.update()
			end,
			update_callback = function(self)
				self.update()
			end,
		},
		buttons = buttons,
	})
end

return taglist

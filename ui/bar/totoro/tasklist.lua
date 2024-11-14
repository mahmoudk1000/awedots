local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")
local helpers = require("helpers")

local tasklist = function(s)
	local tasklist_buttons = awful.util.table.join(
		awful.button({}, awful.button.names.LEFT, function(c)
			if c == client.focus then
				c.minimized = true
			else
				c:emit_signal("request::activate", "tasklist", { raise = true })
			end
		end),
		awful.button({}, awful.button.names.RIGHT, function()
			awful.menu.client_list({ theme = { width = dpi(250) } })
		end),
		awful.button({}, awful.button.names.SCROLL_UP, function()
			awful.client.focus.byidx(1)
		end),
		awful.button({}, awful.button.names.SCROLL_DOWN, function()
			awful.client.focus.byidx(-1)
		end)
	)

	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		layout = {
			spacing_widget = {
				{
					forced_height = dpi(15),
					thickness = dpi(1),
					color = beautiful.xcolor0,
					widget = wibox.widget.separator,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					id = "background_role",
					widget = wibox.container.background,
				},
				shape = function(cr, w, h)
					gears.shape.squircle(cr, w, h, dpi(2))
				end,
				widget = wibox.container.background,
			},
			{
				{
					id = "icon_role",
					halign = "center",
					valign = "center",
					widget = wibox.widget.imagebox,
				},
				margins = dpi(2),
				widget = wibox.container.margin,
			},
			layout = wibox.layout.stack,
			create_callback = function(self, c)
				self.fixes = function()
					local class_icons = {
						["St"] = { icon = "terminal.png", color = beautiful.xcolor4 },
						["FreeTube"] = { icon = "youtube.png", color = beautiful.xcolor1 },
						["obsidian"] = { icon = "obsidian.png", color = beautiful.xcolor5 },
					}
					if class_icons[c.class] then
						self:get_children_by_id("icon_role")[1]
							:set_image(helpers:recolor(class_icons[c.class].icon, class_icons[c.class].color))
					elseif c.icon == nil then
						self:get_children_by_id("icon_role")[1]
							:set_image(helpers:recolor(icons.unknown, beautiful.xcolor1))
					end
				end

				self.fixes()
			end,
			update_callback = function(self)
				self.fixes()
			end,
		},
	})
end

return tasklist

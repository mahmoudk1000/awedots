local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local icons = require("icons")

local helpers = require("helpers")
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

	local tag_properties = {
		[1] = {
			icon = icons.tags["01"],
			color_selected = beautiful.xcolor2,
		},
		[2] = {
			icon = icons.tags["02"],
			color_selected = beautiful.xcolor3,
		},
		[3] = {
			icon = icons.tags["03"],
			color_selected = beautiful.xcolor4,
		},
		[4] = {
			icon = icons.tags["04"],
			color_selected = beautiful.xcolor5,
		},
		[5] = {
			icon = icons.tags["05"],
			color_selected = beautiful.xcolor1,
		},
		[6] = {
			icon = icons.tags["06"],
			color_selected = beautiful.xcolor6,
		},
	}

	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = {
			spacing = dpi(5),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				id = "tag_icon",
				resize = true,
				valign = "center",
				halign = "center",
				widget = wibox.widget.imagebox,
			},
			id = "background_role",
			widget = wibox.container.background,

			create_callback = function(self, t, _)
				local props = tag_properties[t.index]

				self.update = function()
					if t.selected then
						self:get_children_by_id("tag_icon")[1].image =
							gears.surface.load_uncached(helpers:recolor(props.icon, props.color_selected))
					elseif #t:clients() > 0 then
						self:get_children_by_id("tag_icon")[1].image =
							gears.surface.load_uncached(helpers:recolor(props.icon, beautiful.xcolor8))
					else
						self:get_children_by_id("tag_icon")[1].image =
							gears.surface.load_uncached(helpers:recolor(icons.tags["00"], beautiful.xcolor0))
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

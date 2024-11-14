local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons")

local function createElements()
	local elements = wibox.widget({
		spacing = dpi(20),
		layout = wibox.layout.fixed.horizontal,
	})

	local current = 1

	local function updateElements(action)
		action = action or ""
		elements:reset()

		local clients = awful.screen.focused().selected_tag:clients() or client.get()
		local sortedClients = {}

		if client.focus then
			table.insert(sortedClients, client.focus)
		end

		for _, c in ipairs(clients) do
			if c ~= sortedClients[1] then
				table.insert(sortedClients, c)
			end
		end

		for _, c in ipairs(sortedClients) do
			local widget = wibox.widget({
				{
					{
						nil,
						{
							image = c.icon or helpers:recolor(icons.unknown),
							halign = "center",
							widget = wibox.widget.imagebox,
						},
						{
							{
								text = c.name or "Unnamed",
								halign = "center",
								forced_height = dpi(10),
								widget = wibox.widget.textbox,
							},
							margins = { top = dpi(5) },
							layout = wibox.container.margin,
						},
						layout = wibox.layout.align.vertical,
					},
					margins = dpi(10),
					widget = wibox.container.margin,
				},
				bg = beautiful.xbackground,
				forced_width = dpi(120),
				forced_height = dpi(120),
				shape = helpers:rrect(),
				widget = wibox.container.background,
			})
			elements:add(widget)
		end

		if action == "next" then
			current = (current >= #sortedClients) and 1 or current + 1
		end

		for i, element in ipairs(elements.children) do
			element.bg = (i == current) and beautiful.xcolor8 or beautiful.xbackground
		end

		if action == "raise" then
			local c = sortedClients[current]
			if c then
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				c:emit_signal("request::activate")
				c:raise()
			end
			current = 0
		end

		collectgarbage("collect")
		return elements
	end

	elements = updateElements()

	return elements, updateElements
end

awful.screen.connect_for_each_screen(function(s)
	local winlist, updateElements = createElements()

	local container = awful.popup({
		screen = s,
		ontop = true,
		visible = false,
		stretch = false,
		bg = beautiful.xbackground,
		shape = helpers:rrect(),
		placement = awful.placement.centered,
		widget = wibox.container.background,
	})

	container:setup({
		{
			winlist,
			margins = dpi(10),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.vertical,
	})

	local function showSwitcher()
		container.visible = true
		updateElements("next")
	end

	local function hideSwitcher()
		updateElements("raise")
		container.visible = false
		collectgarbage("collect")
	end

	local keygrabber = awful.keygrabber({
		start_callback = showSwitcher,
		stop_callback = function()
			hideSwitcher()
		end,
		keybindings = {
			{
				{ "Mod4" },
				"Tab",
				function()
					updateElements("next")
				end,
				{ description = "Switch to Next Window", group = "Client" },
			},
		},
		stop_key = "Mod4",
		stop_event = "release",
		export_keybindings = true,
		stop_on_event = true,
	})

	awful.keyboard.append_global_keybindings({
		awful.key({ "Mod4" }, "Tab", function()
			if not keygrabber.is_running then
				keygrabber:start()
			end
		end, { description = "Open window switcher", group = "client" }),
	})
end)

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local Gio = require("lgi").Gio
local gears = require("gears")
local helpers = require("helpers")
local fzy = require("module.fzf")
local dpi = beautiful.xresources.apply_dpi

-- Application Launcher class
local AppLauncher = {}
AppLauncher.__index = AppLauncher

function AppLauncher:new()
	local self = setmetatable({}, AppLauncher)

	self.prompt = wibox.widget({
		{
			{
				text = "Run: ",
				font = beautiful.font_bold,
				widget = wibox.widget.textbox,
			},
			{
				id = "input",
				bg = beautiful.xcolor0,
				widget = awful.widget.prompt(),
			},
			forced_height = dpi(30),
			layout = wibox.layout.fixed.horizontal,
		},
		margins = { left = dpi(10) },
		layout = wibox.container.margin,
	})

	self.app_list = wibox.widget({
		spacing = dpi(2),
		horizontal_homogeneous = true,
		horizontal_expand = true,
		layout = wibox.layout.grid,
	})

	self.popup = awful.popup({
		widget = {
			{
				{
					self.prompt,
					bg = beautiful.xcolor0,
					shape = helpers:rrect(beautiful.border_radius / 2),
					layout = wibox.container.background,
				},
				self.app_list,
				spacing = dpi(5),
				forced_width = dpi(300),
				layout = wibox.layout.fixed.vertical,
			},
			color = beautiful.xbackground,
			margins = dpi(10),
			layout = wibox.container.margin,
		},
		ontop = true,
		visible = false,
		shape = helpers:rrect(),
		border_width = beautiful.border_width,
		border_color = beautiful.border_focus,
		placement = awful.placement.centered,
	})

	self.apps = Gio.AppInfo.get_all()
	self.filtered_apps = {}
	self.focus_index = 1
	self.display_start = 1
	self.display_count = 15

	self.keygrabber = awful.keygrabber({
		autostart = true,
		stop_event = "release",
		stop_key = "Escape",
		keypressed_callback = function(_, _, key)
			if key == "Return" then
				self:run()
			elseif key == "BackSpace" then
				self:remove_last_char()
			elseif key == "Up" then
				self:move_focus_up()
			elseif key == "Down" then
				self:move_focus_down()
			elseif key:match("^[a-zA-Z]$") then
				self:add_char(key)
			end
		end,
		stop_callback = function()
			self.popup.visible = false
			collectgarbage("collect")
		end,
	})

	self.popup:connect_signal("button::press", function(_, _, _, button)
		if button == awful.button.names.SCROLL_UP then
			self:move_focus_up()
		elseif button == awful.button.names.SCROLL_DOWN then
			self:move_focus_down()
		end
	end)

	return self
end

function AppLauncher:show()
	self.prompt:get_children_by_id("input")[1].widget:set_text("")
	self.focus_index = 1
	self.display_start = 1
	self:filter_apps("")
	self.popup.visible = true
	self.keygrabber:start()
end

function AppLauncher:hide()
	self.popup.visible = false
	self.keygrabber:stop()
	collectgarbage("collect")
end

function AppLauncher:filter_apps(query)
	local matches = fzy.filter(
		query,
		gears.table.map(function(app)
			return app:get_name()
		end, self.apps)
	)
	self.filtered_apps = gears.table.map(function(match)
		return self.apps[match[1]]
	end, matches)

	self.focus_index = 1
	self.display_start = 1
	self:update_widgets()
	self:highlight_focused_entry()
	collectgarbage("collect")
end

function AppLauncher:update_widgets()
	self.app_list:reset()

	for i = self.display_start, math.min(self.display_start + self.display_count - 1, #self.filtered_apps) do
		local app = self.filtered_apps[i]
		local entry = wibox.widget({
			{
				{
					text = app:get_name(),
					widget = wibox.widget.textbox,
				},
				margins = { left = dpi(5), right = dpi(5), top = dpi(3), bottom = dpi(3) },
				layout = wibox.container.margin,
			},
			bg = beautiful.xbackground,
			shape = helpers:rrect(beautiful.border_radius / 2),
			layout = wibox.container.background,
		})
		self.app_list:add(entry)
	end
end

function AppLauncher:add_char(char)
	local prompt = self.prompt:get_children_by_id("input")[1].widget
	prompt:set_text(prompt.text .. char)
	self:filter_apps(prompt.text)
end

function AppLauncher:remove_last_char()
	local prompt = self.prompt:get_children_by_id("input")[1].widget
	local text = prompt.text
	prompt:set_text(text:sub(1, -2))
	self:filter_apps(prompt.text)
end

function AppLauncher:move_focus_up()
	if self.focus_index > 1 then
		self.focus_index = self.focus_index - 1
	else
		self.focus_index = #self.filtered_apps
		self.display_start = math.max(1, self.focus_index - self.display_count + 1)
	end
	self:check_scroll()
	self:highlight_focused_entry()
end

function AppLauncher:move_focus_down()
	if self.focus_index < #self.filtered_apps then
		self.focus_index = self.focus_index + 1
	else
		self.focus_index = 1
		self.display_start = 1
	end
	self:check_scroll()
	self:highlight_focused_entry()
end

function AppLauncher:check_scroll()
	if self.focus_index < self.display_start then
		self.display_start = self.focus_index
	elseif self.focus_index > self.display_start + self.display_count - 1 then
		self.display_start = self.focus_index - self.display_count + 1
	end
	self:update_widgets()
end

function AppLauncher:highlight_focused_entry()
	for i, widget in ipairs(self.app_list.children) do
		if i == self.focus_index - self.display_start + 1 then
			widget.fg = beautiful.xcolor4
			widget.bg = beautiful.xcolor8
		else
			widget.fg = beautiful.xforeground
			widget.bg = beautiful.xbackground
		end
	end
end

function AppLauncher:run()
	if self.focus_index > 0 then
		local app = self.filtered_apps[self.focus_index]
		if app then
			app:launch()
			self:hide()
		end
	end
end

function _G.show_app_launcher()
	local launcher = AppLauncher:new()
	launcher:show()
end

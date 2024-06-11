local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local Gio = require("lgi").Gio
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

-- Application Launcher class
local AppLauncher = {}
AppLauncher.__index = AppLauncher

function AppLauncher:new()
	local self = setmetatable({}, AppLauncher)

	self.textbox = wibox.widget({
		{
			{
				id = "prompt",
				text = "Run: ",
				widget = wibox.widget.textbox,
			},
			margins = { left = dpi(10) },
			layout = wibox.container.margin,
		},
		{
			id = "input",
			widget = wibox.widget.textbox,
		},
		layout = wibox.layout.fixed.horizontal,
	})

	self.app_list = wibox.widget({
		forced_num_cols = 1,
		spacing = dpi(2),
		horizontal_homogeneous = true,
		horizontal_expand = true,
		layout = wibox.layout.grid,
	})

	self.popup = awful.popup({
		widget = {
			{
				self.textbox,
				forced_height = dpi(30),
				bg = beautiful.xcolor0,
				layout = wibox.container.background,
			},
			{
				self.app_list,
				margins = dpi(5),
				widget = wibox.container.margin,
			},
			forced_width = dpi(300),
			layout = wibox.layout.fixed.vertical,
		},
		ontop = true,
		visible = false,
		shape = helpers:rrect(),
		border_width = beautiful.border_width,
		border_color = beautiful.border_focus,
		placement = awful.placement.centered,
	})

	self.apps = {}
	self.filtered_apps = {}
	self.widgets = {}
	self.focus_index = 1
	self.display_start = 1
	self.display_count = 20

	self:fetch_applications()
	self:create_widgets()

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
		end,
	})

	return self
end

function AppLauncher:fetch_applications()
	self.apps = Gio.AppInfo.get_all()
end

function AppLauncher:create_widgets()
	for i = 1, self.display_count do
		local widget = wibox.widget({
			{
				id = "text_role",
				text = "",
				widget = wibox.widget.textbox,
			},
			bg = beautiful.xbackground,
			widget = wibox.container.background,
		})
		table.insert(self.widgets, widget)
		self.app_list:add(widget)
	end
end

function AppLauncher:show()
	self.textbox.input.text = ""
	self.focus_index = 1
	self.display_start = 1
	self:filter_apps("")
	self.popup.visible = true
	self.keygrabber:start()
end

function AppLauncher:hide()
	self.popup.visible = false
	self.keygrabber:stop()
end

function AppLauncher:filter_apps(query)
	local seen = {}
	query = query:lower()
	self.filtered_apps = {}

	for _, app in ipairs(self.apps) do
		local app_name = app:get_name():lower()
		if app_name:find(query) and not seen[app_name] then
			table.insert(self.filtered_apps, app)
			seen[app_name] = true
		end
	end

	self.focus_index = 1
	self.display_start = 1
	self:update_widgets()
	self:highlight_focused_entry()
end

function AppLauncher:update_widgets()
	for i = 1, self.display_count do
		local index = self.display_start + i - 1
		local widget = self.widgets[i]

		if index <= #self.filtered_apps then
			local app = self.filtered_apps[index]
			widget:get_children_by_id("text_role")[1].text = app:get_name()
			widget.visible = true
		else
			widget.visible = false
		end
	end
end

function AppLauncher:add_char(char)
	self.textbox.input.text = self.textbox.input.text .. char
	self:filter_apps(self.textbox.input.text)
end

function AppLauncher:remove_last_char()
	local text = self.textbox.input.text
	self.textbox.input.text = text:sub(1, -2)
	self:filter_apps(self.textbox.input.text)
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
			widget.shape = helpers:rrect(2)
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

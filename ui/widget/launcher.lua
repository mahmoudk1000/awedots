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

	self.textbox = wibox.widget({
		{
			{
				id = "prompt",
				text = "Run: ",
				widget = wibox.widget.textbox,
			},
			{
				id = "input",
				bg = beautiful.xcolor0,
				widget = awful.widget.prompt(),
			},
			layout = wibox.layout.fixed.horizontal,
		},
		margins = { left = dpi(5) },
		layout = wibox.container.margin,
	})

	self.app_list = wibox.widget({
		spacing = dpi(2),
		layout = wibox.layout.fixed.vertical,
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
	self.focus_index = 1
	self.display_start = 1
	self.display_count = 15

	self:fetch_applications()

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

	self.popup:connect_signal("button::press", function(_, _, _, button)
		if button == 4 then
			self:move_focus_up()
		elseif button == 5 then
			self:move_focus_down()
		end
	end)

	return self
end

function AppLauncher:fetch_applications()
	local apps = Gio.AppInfo.get_all()
	local seen_apps = {}
	self.apps = {}

	for _, app in ipairs(apps) do
		local app_name = app:get_name()
		if not seen_apps[app_name] then
			table.insert(self.apps, app)
			seen_apps[app_name] = true
		end
	end

	self.filtered_apps = self.apps
end

function AppLauncher:show()
	self.textbox:get_children_by_id("input")[1].widget:set_text("")
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
end

function AppLauncher:update_widgets()
	self.app_list:reset()
	for i = self.display_start, math.min(self.display_start + self.display_count - 1, #self.filtered_apps) do
		local app = self.filtered_apps[i]
		local widget = wibox.widget({
			{
				text = app:get_name(),
				forced_height = dpi(20),
				widget = wibox.widget.textbox,
			},
			bg = beautiful.xbackground,
			layout = wibox.container.background,
		})
		self.app_list:add(widget)
	end
end

function AppLauncher:add_char(char)
	local prompt_widget = self.textbox:get_children_by_id("input")[1].widget
	prompt_widget:set_text(prompt_widget.text .. char)
	self:filter_apps(prompt_widget.text)
end

function AppLauncher:remove_last_char()
	local prompt_widget = self.textbox:get_children_by_id("input")[1].widget
	local text = prompt_widget.text
	prompt_widget:set_text(text:sub(1, -2))
	self:filter_apps(prompt_widget.text)
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

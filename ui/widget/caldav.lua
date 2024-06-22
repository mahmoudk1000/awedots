local awful = require("awful")
local wibox = require("wibox")
local json = require("json")
local gears = require("gears")

local CalendarWidget = {}
CalendarWidget.__index = CalendarWidget

-- Constructor
function CalendarWidget:new(nextcloud_url, username, password)
	local self = setmetatable({}, CalendarWidget)
	self.nextcloud_url = nextcloud_url
	self.username = username
	self.password = password
	self.events = {}

	-- Create widget UI
	self.widget = wibox.widget({
		layout = wibox.layout.fixed.vertical,
		spacing = 10,
		{
			widget = wibox.widget.textbox,
			text = "Nextcloud Calendar",
		},
		self:create_events_list(),
		self:create_add_event_button(),
	})

	-- Fetch initial events
	self:fetch_events()

	return self
end

-- Fetch events from Nextcloud
function CalendarWidget:fetch_events()
	local cmd = string.format(
		'curl -u "%s:%s" -X GET "%s/remote.php/dav/calendars/%s/events.json"',
		self.username,
		self.password,
		self.nextcloud_url,
		self.username
	)
	awful.spawn.easy_async_with_shell(cmd, function(stdout)
		local response = json.decode(stdout)
		if response and response.data then
			self.events = response.data
			self:update_events_list()
		end
	end)
end

-- Update events list UI
function CalendarWidget:update_events_list()
	self.events_list:reset()
	for _, event in ipairs(self.events) do
		self.events_list:add(self:create_event_widget(event))
	end
end

-- Create events list UI
function CalendarWidget:create_events_list()
	self.events_list = wibox.layout.fixed.vertical()
	return self.events_list
end

-- Create single event UI
function CalendarWidget:create_event_widget(event)
	local event_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = 5,
		{
			widget = wibox.widget.textbox,
			text = event.summary,
		},
		{
			widget = wibox.widget.textbox,
			text = event.start,
		},
		self:create_edit_event_button(event),
		self:create_delete_event_button(event),
	})
	return event_widget
end

-- Create add event button
function CalendarWidget:create_add_event_button()
	local button = wibox.widget({
		widget = wibox.widget.textbox,
		text = "Add Event",
	})

	button:connect_signal("button::press", function()
		self:add_event()
	end)

	return button
end

-- Add new event
function CalendarWidget:add_event()
	awful.prompt.run({
		prompt = "Event summary: ",
		textbox = awful.screen.focused().mypromptbox.widget,
		exe_callback = function(summary)
			if not summary or #summary == 0 then
				return
			end
			awful.prompt.run({
				prompt = "Event start (YYYY-MM-DD): ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = function(start)
					if not start or #start == 0 then
						return
					end
					local cmd = string.format(
						'curl -u "%s:%s" -X POST "%s/remote.php/dav/calendars/%s/events.json" '
							.. '-d \'{"summary":"%s","start":"%s"}\'',
						self.username,
						self.password,
						self.nextcloud_url,
						self.username,
						summary,
						start
					)
					awful.spawn.easy_async_with_shell(cmd, function()
						self:fetch_events()
					end)
				end,
			})
		end,
	})
end

-- Edit event button
function CalendarWidget:create_edit_event_button(event)
	local button = wibox.widget({
		widget = wibox.widget.textbox,
		text = "Edit",
	})

	button:connect_signal("button::press", function()
		self:edit_event(event)
	end)

	return button
end

-- Edit event
function CalendarWidget:edit_event(event)
	awful.prompt.run({
		prompt = "New summary: ",
		textbox = awful.screen.focused().mypromptbox.widget,
		exe_callback = function(new_summary)
			if not new_summary or #new_summary == 0 then
				return
			end
			awful.prompt.run({
				prompt = "New start (YYYY-MM-DD): ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = function(new_start)
					if not new_start or #new_start == 0 then
						return
					end
					local cmd = string.format(
						'curl -u "%s:%s" -X PUT "%s/remote.php/dav/calendars/%s/events/%s.json" '
							.. '-d \'{"summary":"%s","start":"%s"}\'',
						self.username,
						self.password,
						self.nextcloud_url,
						self.username,
						event.id,
						new_summary,
						new_start
					)
					awful.spawn.easy_async_with_shell(cmd, function()
						self:fetch_events()
					end)
				end,
			})
		end,
	})
end

-- Delete event button
function CalendarWidget:create_delete_event_button(event)
	local button = wibox.widget({
		widget = wibox.widget.textbox,
		text = "Delete",
	})

	button:connect_signal("button::press", function()
		self:delete_event(event)
	end)

	return button
end

-- Delete event
function CalendarWidget:delete_event(event)
	local cmd = string.format(
		'curl -u "%s:%s" -X DELETE "%s/remote.php/dav/calendars/%s/events/%s.json"',
		self.username,
		self.password,
		self.nextcloud_url,
		self.username,
		event.id
	)
	awful.spawn.easy_async_with_shell(cmd, function()
		self:fetch_events()
	end)
end

local nextcloud_url = "https://your-nextcloud-url"
local username = "your-username"
local password = "your-password"

function _G.show_calendar_widget()
	local calendar_widget = CalendarWidget:new(nextcloud_url, username, password)
	local calendar_wibox = awful.wibar({
		position = "top",
		screen = awful.screen.focused(),
		widget = calendar_widget.widget,
	})
	calendar_wibox.visible = true
end

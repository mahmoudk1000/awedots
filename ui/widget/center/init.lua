local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local gfs = gears.filesystem
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local s = awful.screen.focused().geometry
local recolor = gears.color.recolor_image
local res_path = gfs.get_configuration_dir() .. "theme/res/"

local helpers = require("helpers")
local sys_stuff = require("signal.sys")

local calendar = require(... .. ".calendar")
local tinyboard = require(... .. ".tinyboard")
local player = require(... .. ".player")

local weather_stuff = require("signal.weather")
local wifi_stuff = require("signal.wifi")

local function powerOptions(icon, color, command)
	return wibox.widget({
		{
			{
				image = recolor(res_path .. icon, color),
				resize = true,
				forced_height = dpi(25),
				forced_width = dpi(25),
				widget = wibox.widget.imagebox,
			},
			buttons = gears.table.join(awful.button({}, awful.button.names.LEFT, function()
				awful.spawn.with_shell(command)
			end)),
			margins = dpi(5),
			layout = wibox.container.margin,
		},
		bg = color .. "50",
		shape = helpers:rrect(0),
		layout = wibox.container.background,
	})
end

local poweroff = powerOptions("shutdown.png", beautiful.xcolor1, "systemctl poweroff")
local extraOptions = {
	powerOptions("reboot.png", beautiful.xcolor2, "systemctl reboot"),
	powerOptions("suspend.png", beautiful.xcolor5, "systemctl suspend"),
	powerOptions("logout.png", beautiful.xcolor6, "pkill -KILL -u $USER"),
}
local expanded = false

local power_widget = wibox.widget({
	{
		{
			{
				id = "arrow",
				markup = helpers:color_markup("", beautiful.xcolor4),
				widget = wibox.widget.textbox,
			},
			margins = dpi(5),
			layout = wibox.container.margin,
		},
		bg = beautiful.xcolor4 .. "50",
		shape = helpers:rrect(0),
		widget = wibox.container.background,
	},
	poweroff,
	layout = wibox.layout.fixed.horizontal,
})

power_widget.children[1].buttons = gears.table.join(awful.button({}, awful.button.names.LEFT, function()
	if expanded then
		for i = #power_widget.children - 1, 2, -1 do
			power_widget:remove(i)
		end
		expanded = false
		power_widget:get_children_by_id("arrow")[1]:set_markup(helpers:color_markup("", beautiful.xcolor4))
	else
		for _, option in ipairs(extraOptions) do
			table.insert(power_widget.children, 2, option)
		end
		expanded = true
		power_widget:get_children_by_id("arrow")[1]:set_markup(helpers:color_markup("", beautiful.xcolor4))
	end
end))

local avatar = wibox.widget({
	image = res_path .. "me.png",
	resize = true,
	forced_height = dpi(25),
	forced_width = dpi(25),
	clip_shape = function(cr, w, h)
		gears.shape.circle(cr, w, h)
	end,
	widget = wibox.widget.imagebox,
})

local uptime = wibox.widget({
	markup = "3H 12M",
	widget = wibox.widget.textbox,
})

local uptime_updater = gears.timer({
	timeout = 30,
	call_now = true,
	callback = function()
		sys_stuff:emit_uptime()
	end,
})

awesome.connect_signal("uptime::info", function(hours, minutes)
	if hours == 0 then
		uptime:set_markup(string.format("%02dM", minutes))
	else
		uptime:set_markup(string.format("%02dH %02dM", hours, minutes))
	end
end)

local center_controls = wibox.widget({
	{
		tinyboard.toggles,
		{
			tinyboard.sliders,
			player,
			layout = wibox.layout.flex.horizontal,
		},
		layout = wibox.layout.align.vertical,
	},
	calendar(),
	forced_width = s.width / 2.5,
	forced_height = s.height / 4,
	layout = wibox.layout.ratio.horizontal,
})

center_controls:adjust_ratio(2, 2 / 3, 1 / 3, 0)

-- Create Center Widget
local center_popup = awful.popup({
	widget = {
		{
			{
				{
					{
						{
							{
								avatar,
								{
									{
										text = "Mahmoud",
										font = beautiful.font_bold,
										widget = wibox.widget.textbox,
									},
									uptime,
									layout = wibox.layout.flex.vertical,
								},
								spacing = dpi(10),
								forced_height = dpi(20),
								layout = wibox.layout.fixed.horizontal,
							},
							margins = dpi(5),
							layout = wibox.container.margin,
						},
						bg = beautiful.xcolor0,
						shape = helpers:rrect(),
						layout = wibox.container.background,
					},
					nil,
					{
						{
							power_widget,
							shape = helpers:rrect(),
							layout = wibox.container.background,
						},
						spacing = dpi(10),
						layout = wibox.layout.fixed.horizontal,
					},
					layout = wibox.layout.align.horizontal,
				},
				margins = dpi(5),
				layout = wibox.container.margin,
			},
			center_controls,
			layout = wibox.layout.align.vertical,
		},
		margins = dpi(10),
		layout = wibox.container.margin,
	},
	ontop = true,
	visible = false,
	border_color = beautiful.border_normal,
	border_width = beautiful.border_width,
	shape = helpers:rrect(),
	placement = function(c)
		awful.placement.bottom(
			c,
			{ margins = { bottom = dpi(30) + (beautiful.useless_gap * 2) }, parent = awful.screen.focused() }
		)
	end,
})

awesome.connect_signal("clock::clicked", function()
	if center_popup.visible then
		uptime_updater:stop()
		center_popup.visible = false
	else
		wifi_stuff:emit_wifi_info()
		sys_stuff:emit_uptime()
		center_popup.visible = true
		uptime_updater:start()
	end
end)

center_popup:connect_signal("mouse::leave", function()
	uptime_updater:stop()
	center_popup.visible = false
end)

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local icons = require("icons")
local helpers = require("helpers")
local apps = require("config.apps")

_G.menu = {}
local section = {}

section.awesome = {
	{ "Restart", awesome.restart, helpers:recolor(icons.power.reboot) },
	{
		"Quit",
		function()
			awesome.quit()
		end,
		helpers:recolor(icons.power.shutdown),
	},
}

section.scrots = {
	{ "Full", "flameshot full" },
	{ "Full 5s", "flameshot full -d 5000" },
	{ "Partial", "flameshot gui" },
}

section.power = {
	{ "Suspend", "systemctl suspend", helpers:recolor(icons.power.suspend, beautiful.xcolor2) },
	{ "Reboot", "systemctl reboot", helpers:recolor(icons.power.reboot, beautiful.xcolor3) },
	{ "Shutdown", "systemctl poweroff", helpers:recolor(icons.power.shutdown, beautiful.xcolor1) },
}

menu.main = awful.menu({
	items = {
		{ "Terminal", apps.default.terminal, helpers:recolor(icons.apps.terminal) },
		{ "Browser", apps.default.browser, helpers:recolor(icons.apps.browser) },
		{ "Files", apps.default.filemanager, helpers:recolor(icons.apps.files) },
		{ "Scrots", section.scrots, helpers:recolor(icons.screenshot) },
		{ "Awesome", section.awesome },
		{ "Power", section.power },
	},
})

menu.main.wibox:set_widget(wibox.widget({
	{
		menu.main.wibox.widget,
		layout = wibox.container.background,
	},
	margins = dpi(10),
	layout = wibox.container.margin,
}))

awful.menu.old_new = awful.menu.new

function awful.menu.new(...)
	local submenu = awful.menu.old_new(...)
	submenu.wibox.bg = beautiful.menu_bg_normal
	submenu.wibox.border_width = beautiful.menu_border_width
	submenu.wibox.border_color = beautiful.menu_border_color
	submenu.wibox:set_widget(wibox.widget({
		{
			submenu.wibox.widget,
			layout = wibox.container.background,
		},
		color = beautiful.menu_bg_normal,
		margins = dpi(10),
		layout = wibox.container.margin,
	}))
	return submenu
end

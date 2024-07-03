local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")
local apps = require("config.apps")

local icon_terminal = helpers:recolor("terminal.png")
local icon_browser = helpers:recolor("browser.png")
local icon_files = helpers:recolor("files.png")
local icon_scrots = helpers:recolor("scrots.png")
local icon_power = helpers:recolor("shutdown.png", beautiful.xcolor1)
local icon_reboot = helpers:recolor("reboot.png", beautiful.xcolor3)
local icon_suspend = helpers:recolor("suspend.png", beautiful.xcolor2)
local icon_logout = helpers:recolor("logout.png", beautiful.xcolor1)

_G.menu = {}
local section = {}

section.awesome = {
	{ "Restart", awesome.restart, icon_reboot },
	{
		"Quit",
		function()
			awesome.quit()
		end,
		icon_logout,
	},
}

section.scrots = {
	{ "Full", "flameshot full" },
	{ "Full 5s", "flameshot full -d 5000" },
	{ "Partial", "flameshot gui" },
}

section.power = {
	{ "Suspend", "systemctl suspend", icon_suspend },
	{ "Reboot", "systemctl reboot", icon_reboot },
	{ "Shutdown", "systemctl poweroff", icon_power },
}

menu.main = awful.menu({
	items = {
		{ "Terminal", apps.default.terminal, icon_terminal },
		{ "Browser", apps.default.browser, icon_browser },
		{ "Files", apps.default.filemanager, icon_files },
		{ "Scrots", section.scrots, icon_scrots },
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

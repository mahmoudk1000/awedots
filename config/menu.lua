local awful	= require("awful")
local gears	= require("gears")
local beautiful = require("beautiful")
local res_path  = gears.filesystem.get_configuration_dir() .. "theme/res/"
local recolor   = gears.color.recolor_image


local icon_terminal = recolor(res_path .. "terminal.png", beautiful.xcolor4)
local icon_browser = recolor(res_path .. "browser.png", beautiful.xcolor4)
local icon_files = recolor(res_path .. "files.png", beautiful.xcolor4)
local icon_scrots = recolor(res_path .. "scrots.png", beautiful.xcolor4)
local icon_power = recolor(res_path .. "shutdown.png", beautiful.xcolor4)

local awesome_menu = {
    { "Restart", awesome.restart },
    { "Quit", awesome.quit }
}

local scrots_menu = {
    { "Full", "flameshot full" },
    { "Full 5s", "flameshot full -d 5000" },
    { "Partial", "flameshot gui" }
}

local power = {
    { "Shutdown", "systemctl poweroff" },
    { "Reboot", "systemctl reboot" },
    { "Suspend", "systemctl suspend" }
}

TheMenu = awful.menu {
    items = {
	{ "Terminal", terminal, icon_terminal },
	{ "Browser", browser, icon_browser },
	{ "Files", filemanager, icon_files },
	{ "Scrots", scrots_menu, icon_scrots },
	{ "Awesome", awesome_menu },
	{ "Power", power, icon_power }
    }
}

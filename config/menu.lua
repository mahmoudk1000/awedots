local awful	= require("awful")
local gears	= require("gears")
local beautiful = require("beautiful")
local res_path  = gears.filesystem.get_configuration_dir() .. "theme/res/"
local recolor   = gears.color.recolor_image


local icon_terminal = recolor(res_path .. "terminal.png", beautiful.xcolor4)
local icon_browser = recolor(res_path .. "browser.png", beautiful.xcolor4)
local icon_files = recolor(res_path .. "files.png", beautiful.xcolor4)
local icon_scrots = recolor(res_path .. "scrots.png", beautiful.xcolor4)

local awesome_menu = {
    { "Config", editor_cmd .. " " .. gears.filesystem.get_configuration_dir() },
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end },
}

local scrots_menu = {
    { "Full", "flameshot full -p /home/mahmoud/Scrots" },
    { "Full 5s", "flameshot full -d 5000 -p /home/mahmoud/Scrots" },
    { "Partial", "flameshot gui -p /home/mahmoud/Scrots" }
}

das_menu = awful.menu {
    items = {
	{ "Terminal", terminal },
	{ "Browser", browser },
	{ "Files", filemanager },
	{ "Scrots", scrots_menu },
	{ "Awesome", awesome_menu }
    }
}

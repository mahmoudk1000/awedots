local menu  = require("awful.menu")
local gears = require("gears")

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

das_menu = menu({
    items = {
	{ "Terminal", terminal },
	{ "Browser", browser },
	{ "Files", filemanager },
	{ "Scrots", scrots_menu },
	{ "Awesome", awesome_menu }
    }
})

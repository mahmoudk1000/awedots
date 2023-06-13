local gears = require("gears")
local awful = require("awful")

awesomemenu = {
    { "Config", editor_cmd .. " " .. gears.filesystem.get_configuration_dir() },
    { "Restart", awesome.restart },
    { "Quit", function() awesome.quit() end },
}

screenshotmenu = {
    { "Full", "flameshot full -p /home/mahmoud/Scrots" },
    { "Full 5s", "flameshot full -d 5000 -p /home/mahmoud/Scrots" },
    { "Partial", "flameshot gui -p /home/mahmoud/Scrots" }
}

awemenu = awful.menu(
    { items = {
	{ "Awesome", awesomemenu },
        { "Shot", screenshotmenu },
	{ "Terminal", terminal },
	{ "Browser", browser },
	{ "Files", filemanager }
    }
})

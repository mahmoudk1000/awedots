awesomemenu = {
	{ "Config", editor_cmd .. " " .. require("gears").filesystem.get_configuration_dir() },
	{ "Restart", awesome.restart },
	{ "Quit", function() awesome.quit() end },
}

screenshotmenu = {
	{ "Full", "flameshot full -p /home/mahmoud/Scrots" },
	{ "Full 5s", "flameshot full -d 5000 -p /home/mahmoud/Scrots" },
	{ "Partial", "flameshot gui -p /home/mahmoud/Scrots" }
}

awemenu = require("awful").menu(
	{ items = {
		{ "Awesome", awesomemenu },
		{ "Shot", screenshotmenu },
		{ "Terminal", terminal },
		{ "Browser", browser },
		{ "Files", filemanager }
    }
})

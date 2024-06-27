-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
require("naughty").connect_signal("request::display_error", function(message, startup)
	require("naughty").notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)
-- }}}

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
require("gears").timer({
	timeout = 300,
	autostart = true,
	call_now = true,
	callback = function()
		collectgarbage("collect")
	end,
})

-- Theme
require("theme")

-- Imports
require("config")
require("signal")
require("ui")

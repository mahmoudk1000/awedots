-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local gfs = require("gears.filesystem")
local beautiful = require("beautiful")
local naughty = require("naughty")
local ruled = require("ruled")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
-- }}}

-- Themes define colours, icons, font and wallpapers
local theme_path = gears.filesystem.get_configuration_dir() .. string.format("themes/%s/theme.lua", "dunkelblau")
beautiful.init(theme_path)

-- Import Configuration
require("awful.autofocus")
require("configuration")
require("ui")

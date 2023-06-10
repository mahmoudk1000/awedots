-- autostart.lua
-- Autostart Stuff Here
local awful = require("awful")

-- Add apps to autostart here
local autostart_apps = {
    "xset r 200 30",
    "xsetroot -cursor_name left_ptr",
    "unclutter -idle 2",
    "flameshot",
    "picom --experimental-backends -b",
    "mpv",
}

for app = 1, #autostart_apps do
    awful.spawn.single_instance(autostart_apps[app], awful.rules.rules)
end


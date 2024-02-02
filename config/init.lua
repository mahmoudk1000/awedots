-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey  = "Mod4"
alt     = "Mod1"
shift   = "Shift"
ctrl    = "Control"

-- This is used later as the default terminal and editor to run.
terminal    = "st"
browser     = "firefox"
rofi        = "rofi -show drun"
filemanager = "thunar"
obsidian    = "obsidian"

-- Set Keys and window
require("config.keys")
require("config.menu")
require("config.notification")
require("config.window")

-- Other Stuff
require("awful.autofocus")

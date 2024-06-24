-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
alt = "Mod1"
shift = "Shift"
ctrl = "Control"

-- Focus
require("awful.autofocus")

-- Set Keys and window
require(... .. ".bling")
require(... .. ".keys")
require(... .. ".layout")
require(... .. ".menu")
require(... .. ".notification")
require(... .. ".ruled")
require(... .. ".tag")
require(... .. ".titlebar")
require(... .. ".window")

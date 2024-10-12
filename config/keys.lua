local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local volume_stuff = require("signal.volume")
local backlight_stuff = require("signal.backlight")

local apps = require("config.apps")

local mouse_keybinds = {}
local client_keybinds = {}

local function parseKey(keyStr, delimStr)
	local delim = delimStr or "+"
	local mods = {}
	local keybind = ""
	local MODS = {
		["Super"] = "Mod4",
		["Alt"] = "Mod1",
		["Shift"] = "Shift",
		["Ctrl"] = "Control",
	}

	for key in keyStr:gmatch("([^" .. delim .. "]+)") do
		if MODS[key] then
			table.insert(mods, MODS[key])
		else
			keybind = keybind .. key
		end
	end
	return mods, keybind
end

local function bind(keys, func, desc, group)
	local m, k = parseKey(keys)
	local binding = {}

	binding.modifiers = m
	binding.description = desc or nil
	binding.group = group or nil
	binding.on_press = func

	for _, kg in ipairs({ "numrow", "arrows", "fkeys", "numpad" }) do
		if k == kg then
			binding.keygroup = k
			break
		else
			binding.key = k
		end
	end

	return awful.key(binding)
end

local function gkbind(...)
	awful.keyboard.append_global_keybindings({ bind(...) })
end

local function ckbind(...)
	client_keybinds[#client_keybinds + 1] = bind(...)
end

local function gmbind(...)
	awful.mouse.append_global_mousebindings({ bind(...) })
end

local function cmbind(...)
	mouse_keybinds[#mouse_keybinds + 1] = bind(...)
end

-- Mouse
awful.mouse.append_global_mousebindings({
	awful.button({}, awful.button.names.LEFT, function()
		menu.main:hide()
		bye.visible = false
	end),
	awful.button({}, awful.button.names.RIGHT, function()
		menu.main:toggle()
	end),
	awful.button({}, awful.button.names.SCROLL_UP, awful.tag.viewprev),
	awful.button({}, awful.button.names.SCROLL_DOWN, awful.tag.viewnext),
})

client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_global_mousebindings(mouse_keybinds)
	awful.mouse.append_client_mousebindings({
		awful.button({}, awful.button.names.LEFT, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ "Mod4" }, awful.button.names.LEFT, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ "Mod4" }, awful.button.names.RIGHT, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)

-- Awesome Bindings
gkbind("Super+F1", hotkeys_popup.show_help, "Show Help", "AwesomeWM")
gkbind("Super+Alt+r", awesome.restart, "Restart", "AwesomeWM")
gkbind("Super+Shift+q", awesome.quit, "Quit", "AwesomeWM")
gkbind("Super+l", function()
	awful.spawn({ "betterlockscreen", "-l" })
end, "Lock Screen", "AwesomeWM")
gkbind("Super+p", function()
	bye.visible = not bye.visible
end, "Run Power Menu", "AwesomeWM")
gkbind("Super+c", function()
	awesome.emit_signal("shion::toggle")
end, "Toggle Control Center", "AwesomeWM")

-- Layout Bindings
gkbind("Super+space", function()
	awful.layout.inc(1)
end, "select next", "Layout")
gkbind("Super+Shift", "space", function()
	awful.layout.inc(-1)
end, "select previous", "Layout")

-- Applications Bindings
gkbind("Super+Return", function()
	awful.spawn(apps.default.terminal)
end, "Open Terminal", "Launcher")
gkbind("Super+d", function()
	show_app_launcher()
end, "Applications Launcher", "Launcher")
gkbind("Super+w", function()
	awful.spawn(apps.default.browser)
end, "Launch Browser", "Launcher")
gkbind("Super+Shift+w", function()
	awful.spawn(apps.default.browser .. " -P Work")
end, "Firefox Work Profile", "Launcher")
gkbind("Super+f", function()
	awful.spawn(apps.default.filemanager)
end, "Launch Filemanager", "Launcher")
gkbind("Super+o", function()
	awful.spawn(apps.default.obsidian)
end, "Launch Obsidian", "Launcher")
gkbind("Super+b", function()
	awful.spawn("blum")
end, "Spawn Bluetooth Menu", "Launcher")

-- Volume
gkbind("XF86AudioRaiseVolume", function()
	awful.spawn.easy_async({ "pamixer", "-i", "5" }, function()
		volume_stuff:emit_volume_state()
		awesome.emit_signal("volume::pop")
	end)
end, "Increase Volume", "System")
gkbind("Ctrl+XF86AudioRaiseVolume", function()
	awful.spawn.easy_async({ "pamixer", "--allow-boost", "-i", "10" }, function()
		volume_stuff:emit_volume_state()
	end)
end, "Boost Volume", "System")
gkbind("XF86AudioLowerVolume", function()
	awful.spawn.easy_async({ "pamixer", "-d", "5" }, function()
		volume_stuff:emit_volume_state()
		awesome.emit_signal("volume::pop")
	end)
end, "Decrease Volume", "System")
gkbind("XF86AudioMute", function()
	awful.spawn.easy_async({ "pamixer", "--toggle-mute" }, function()
		volume_stuff:emit_volume_state()
		awesome.emit_signal("volume::pop")
	end)
end, "Toggle Mute", "System")

-- Brightness
gkbind("XF86MonBrightnessUp", function()
	awful.spawn.easy_async({ "brightnessctl", "s", "+10%" }, function()
		backlight_stuff:emit_backlight_info()
		awesome.emit_signal("backlight::pop")
	end)
end, "Increase Brightness", "System")
gkbind("XF86MonBrightnessDown", function()
	awful.spawn.easy_async({ "brightnessctl", "s", "10%-" }, function()
		backlight_stuff:emit_backlight_info()
		awesome.emit_signal("backlight::pop")
	end)
end, "Decrease Brightness", "System")

-- Music
gkbind("XF86AudioPlay", function()
	awful.spawn({ "playerctl", "play-pause" })
end, "Toggle Playerctl", "Music")
gkbind("XF86AudioPrev", function()
	awful.spawn({ "playerctl", "previous" })
end, "Playerctl Previous", "Music")
gkbind("XF86AudioNext", function()
	awful.spawn({ "playerctl", "next" })
end, "Playerctl Next", "Music")

gkbind("Ctrl+XF86AudioPlay", function()
	awful.spawn({ "mpc", "toggle" })
end, "Playerctl Next", "Music")
gkbind("Ctrl+XF86AudioNext", function()
	awful.spawn({ "mpc", "next" })
end, "Playerctl Next", "Music")
gkbind("Ctrl+XF86AudioPrev", function()
	awful.spawn({ "mpc", "prev" })
end, "Playerctl Next", "Music")

-- Scrots
gkbind("Print", function()
	awful.spawn({ "flameshot", "full" })
end, "Take a Full Screenshot", "Scrots")
gkbind("Shift+Print", function()
	awful.spawn({ "flameshot", "gui" })
end, "Take a Partial Screenshot", "Scrots")
gkbind("Alt+Print", function()
	awful.spawn({ "flameshot", "full", "-d 5000" })
end, "Take a Delayed Screenshot", "Scrots")

-- Workspace Bindings
gkbind("Super+a", function()
	awful.tag.viewprev()
end, "Move Previous Workspace", "Workspace")
gkbind("Super+s", function()
	awful.tag.viewnext()
end, "Move Next Workspace", "Workspace")
gkbind("Super+Escape", function()
	awful.tag.history.restore()
end, "Switch Last Focused Workspace", "Workspace")
gkbind("Super+numrow", function(i)
	local t = awful.screen.focused().tags[i]
	if t then
		t:view_only()
	end
end, "View nth Workspace", "Workspace")
gkbind("Super+Shift+numrow", function(i)
	if client.focus then
		local t = client.focus.screen.tags[i]
		if t then
			client.focus:move_to_tag(t)
		end
	end
end, "Move Client to Workspace", "Workspace")

-- Client
ckbind("Super+j", function()
	awful.client.focus.byidx(1)
end, "Focus Next", "Client")
ckbind("Super+k", function()
	awful.client.focus.byidx(-1)
end, "Focus Previous", "Client")
ckbind("Super+Shift+j", function()
	awful.client.swap.byidx(1)
end, "Swap with Next", "Client")
ckbind("Super+Shift+k", function()
	awful.client.swap.byidx(-1)
end, "Swap with Previous", "Client")
ckbind("Super+Ctrl+l", function()
	if awful.layout.get(client.focus.screen) == awful.layout.suit.spiral.dwindle then
		awful.client.incwfact(0.05)
	else
		awful.tag.incmwfact(0.05)
	end
end, "Increase Window Factor", "Client")
ckbind("Super+Ctrl+h", function()
	if awful.layout.get(client.focus.screen) == awful.layout.suit.spiral.dwindle then
	awful.client.incwfact(-0.05)
	else
		awful.tag.incmwfact(-0.05)
	end
end, "Decrease Window Factor", "Client")
ckbind("Super+Shift+f", function(c)
	c.fullscreen = not c.fullscreen
	c:raise()
end, "Toggle Fullscreen", "Client")
ckbind("Super+q", function(c)
	c:kill()
end, "Close+Client")
ckbind("Super+Shift+t", function(c)
	c.floating = not c.floating
	awful.titlebar.toggle(c)
	c:raise()
end, "Toggle Floating", "Client")
ckbind("Super+t", function(c)
	c.ontop = not c.ontop
end, "Toggle Keep on Top", "Client")
ckbind("Super+n", function(c)
	c.minimized = true
end, "Minimize", "Client")
ckbind("Super+m", function(c)
	c.maximized = not c.maximized
	c:raise()
end, "Maximize", "Client")

-- Client Options Bindings
client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings(client_keybinds)
end)

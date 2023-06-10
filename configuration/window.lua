local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local ruled = require("ruled")
local wibox = require("wibox")
local menubar = require("menubar")

screen.connect_signal("request::desktop_decoration", function(s)
    -- Layout List
    tag.connect_signal("request::default_layouts", function()
    	awful.layout.append_default_layouts({
    	    awful.layout.suit.tile,
			awful.layout.suit.floating,
			-- awful.layout.suit.max,
    	})
	end)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
end)

-- Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                -- upscale   = true,
                -- downscale = true,
                widget    = wibox.widget.imagebox,
            },
            horizontal_fit_policy = "fit",
            vertical_fit_policy   = "fit",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)


--  Rules
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Gpick", "SimpleScreenRecorder"
            },
            name    = {
                "Event Tester",  -- xev
            },
        },
        properties = { floating = true }
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true }
    }

    -- Set Firefox to always map on the tag named "2" on screen 1.
    ruled.client.append_rule {
         rule       = { class = "firefox" },
         properties = { screen = 1, tag = "1" }
    }
    ruled.client.append_rule {
         rule       = { class = "Thunar" },
         properties = { screen = 1, tag = "4" }
    }
    ruled.client.append_rule {
         rule       = { class = "obsidian" },
         properties = { screen = 1, tag = "6" }
    }
    ruled.client.append_rule {
         rule       = { class = "Mailspring" },
         properties = { screen = 1, tag = "7", switchtotag = true }
    }
    ruled.client.append_rule {
         rule       = { class = "TelegramDesktop" },
         properties = { screen = 1, tag = "8" }
    }
    ruled.client.append_rule {
         rule       = { class = "Spotify" },
         properties = { screen = 1, tag = "9" }
    }
end)

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local ruled = require("ruled")
local wibox = require("wibox")
local menubar = require("menubar")


-- Tags and Layouts
screen.connect_signal("request::desktop_decoration", function(s)
    tag.connect_signal("request::default_layouts", function()
    	awful.layout.append_default_layouts({
    	    awful.layout.suit.tile,
	    awful.layout.suit.floating,
	    -- awful.layout.suit.max,
    	})
    end)

    awful.tag({ "1", "2", "3", "4", "5", "6"}, s, awful.layout.layouts[1])
end)


-- Window Bordering
client.connect_signal("manage", function (c, startup)
    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_focus

    c:connect_signal("focus", function()
        c.border_color = beautiful.border_focus
    end)

    c:connect_signal("unfocus", function()
        c.border_color = beautiful.border_normal
    end)

    c:connect_signal("marked", function()
        c.border_color = beautiful.border_marked
    end)
end)


-- Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        bg = {
            type  = "linear" ,
            from  = { 0, 0 },
            to    = { 0, 1240 },
            stops = {
                { 0, beautiful.xcolor4 },
                { 1, beautiful.xcolor12 }
            }
        },
        widget = {
            {
                -- image     = beautiful.wallpaper,
                upscale = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = false,
            widget = wibox.container.tile,
        }
    }
end)


--  Rules
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id = "global",
        rule = { },
        properties = {
            focus       = awful.client.focus.filter,
            raise       = true,
            screen      = awful.screen.preferred,
            size_hints_honor = false,
            placement   = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    ruled.client.append_rule {
	id = "multimedia",
	rule_any = {  
	    class = {
                "vlc",
                "mpv" 
            }
	},
	properties = { 
	    tag = "3",
            switchtotag = true,
            raise = true,
            floating = true,
	    draw_backdrop = false,
            placement = awful.placement.centered
	}
    }

    ruled.client.append_rule {
        id = "Events",
        rule_any = {
            class = {
                "Nsxiv",
            },
            type = {
                "dialog",
	    }
        },
        properties = {
            focus = true,
            ontop = true,
	    floating = true,
	    placement = awful.placement.centered,
	}
    }

    -- Floating clients.
    ruled.client.append_rule {
        id = "floating",
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
         rule       = { class = "thunderbird" },
         properties = { screen = 1, tag = "6" }
    }
    ruled.client.append_rule {
         rule       = { class = "TelegramDesktop" },
         properties = { screen = 1, tag = "5" }
    }
    ruled.client.append_rule {
         rule       = { class = "Spotify" },
         properties = { screen = 1, tag = "5" }
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

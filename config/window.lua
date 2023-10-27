local awful         = require("awful")
local gears         = require("gears")
local beautiful     = require("beautiful")
local ruled         = require("ruled")


-- Wallpaper
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


-- Tags, Layouts and Wallpaper
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    tag.connect_signal("request::default_layouts", function()
    	awful.layout.append_default_layouts({
    	    awful.layout.suit.tile,
            awful.layout.suit.floating,
            -- awful.layout.suit.tile.left,
            -- awful.layout.suit.tile.bottom,
            -- awful.layout.suit.tile.top,
            -- awful.layout.suit.fair,
            -- awful.layout.suit.fair.horizontal,
            -- awful.layout.suit.spiral,
            -- awful.layout.suit.spiral.dwindle,
            -- awful.layout.suit.max,
            -- awful.layout.suit.max.fullscreen,
            -- awful.layout.suit.magnifier,
            -- awful.layout.suit.corner.nw,
            -- awful.layout.suit.corner.ne,
            -- awful.layout.suit.corner.sw,
            -- awful.layout.suit.corner.se,
    	})
    end)

    awful.tag({ "1", "2", "3", "4", "5", "6"}, s, awful.layout.layouts[1])
end)


-- Window Bordering
client.connect_signal("manage", function (c)
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


--  Rules
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id = "global",
        rule = { },
        properties = {
            focus               = awful.client.focus.filter,
            raise               = true,
            screen              = awful.screen.preferred,
            size_hints_honor    = false,
            placement           = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
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

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = {
            type = {
                "normal",
                "dialog"
            }
        },
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
         properties = { screen = 1, tag = "5" }
    }
    ruled.client.append_rule {
         rule       = { class = "TelegramDesktop" },
         properties = { screen = 1, tag = "5" }
    }
    ruled.client.append_rule {
         rule       = { class = "Spotify" },
         properties = { screen = 1, tag = "5" }
    }
    ruled.client.append_rule {
        rule       = { class = "thunderbird" },
        properties = { screen = 1, tag = "6" }
    }
end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

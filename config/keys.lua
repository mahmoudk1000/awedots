local awful             = require("awful")
local hotkeys_popup     = require("awful.hotkeys_popup")

local volume_stuff      = require("signal.volume")
local backlight_stuff   = require("signal.backlight")


-- Awesome Bindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "F1",
            hotkeys_popup.show_help,
        { description="Show Help", group="Awesome"  }),
    awful.key({ modkey, alt }, "r",
            awesome.restart,
        { description = "Reload Awesome", group = "Awesome"  }),
    awful.key({ modkey, shift }, "q",
            awesome.quit,
        { description = "Quit Awesome", group = "Awesome" }),
    awful.key({ modkey }, "Return",
            function () awful.spawn(terminal) end,
        { description = "Open Terminal", group = "Launcher" }),
    awful.key({ modkey }, "d",
           function() awful.spawn(rofi) end,
        { description = "Spawn Rofi", group = "Launcher" }),
    awful.key({ modkey }, "z",
            function() awful.spawn.with_shell("betterlockscreen -l") end,
        { description = "Lock Screen", group = "Awesome" }),
})

-- Tags Bindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "c",
            awful.tag.viewprev,
        { description = "Move Previous", group = "Tag" }),
    awful.key({ modkey }, "v",
            awful.tag.viewnext,
        { description = "Move Next", group = "Tag" }),
    awful.key({ modkey }, "Escape",
            awful.tag.history.restore,
        { description = "Go Back", group = "Tag" }),
    awful.key({ modkey }, "space",
            function () awful.layout.inc(1) end,
        { description = "select next", group = "Layout" }),
    awful.key({ modkey, shift }, "space",
            function () awful.layout.inc(-1) end,
        { description = "select previous", group = "Layout" }),
})

-- Applications Bindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "w",
            function()
                awful.spawn(browser)
            end,
        { description = "Launch Browser", group = "Launcher" }),
    awful.key({ modkey }, "f",
            function()
                awful.spawn(filemanager)
            end,
        { description = "Launch Filemanager", group = "Launcher" }),
    awful.key({ modkey }, "o",
            function()
                awful.spawn(obsidian)
            end,
        { description = "Launch Obsidian", group = "Launcher" }),
    awful.key({ modkey }, "p",
            function()
                awful.spawn("poww")
            end,
        { description = "Spawn Power Menu", group = "Launcher" }),
    awful.key({ modkey }, "b",
            function()
                awful.spawn("blum")
            end,
        { description = "Spawn Bluetooth Menu", group = "Launcher" }),
})

-- System Bindings
awful.keyboard.append_global_keybindings({
    -- Volume
    awful.key({}, "XF86AudioRaiseVolume",
            function()
                awful.spawn({"pamixer", "-i", "5"})
                volume_stuff:emit_volume_state()
            end,
        { description = "Increase Volume", group = "System" }),
        awful.key({ ctrl }, "XF86AudioRaiseVolume",
            function()
                awful.spawn({"pamixer", "--allow-boost", "-i", "10"})
                volume_stuff:emit_volume_state()
            end,
        { description = "Increase Volume", group = "System" }),
    awful.key({}, "XF86AudioLowerVolume",
            function() 
                awful.spawn({"pamixer", "-d", "5"})
                volume_stuff:emit_volume_state()
            end,
        { description = "Decrease Volume", group = "System" }),
    awful.key({}, "XF86AudioMute",
            function() 
                awful.spawn({"pamixer", "--toggle-mute"})
                volume_stuff:emit_volume_state()
            end,
        { description = "Toggle Mute", group = "System" }),
    
    -- Brightness
    awful.key({}, "XF86MonBrightnessUp",
            function()
                awful.spawn({"brightnessctl", "s", "+10%"})
                backlight_stuff:emit_backlight_info()
            end,
        { description = "Increase Brightness", group = "System" }),
    awful.key({}, "XF86MonBrightnessDown",
            function()
                awful.spawn({"brightnessctl", "s", "10%-"})
                backlight_stuff:emit_backlight_info()
            end,
        { description = "Decrease Brightness", group = "System" }),

    -- Music
    awful.key({}, "XF86AudioPlay",
            function()
                awful.spawn({"playerctl", "play-pause"})
            end,
        { description = "Toggle Playerctl", group = "Music" }),
    awful.key({}, "XF86AudioPrev",
            function()
                awful.spawn({"playerctl", "previous"})
            end,
        { description = "Playerctl Previous", group = "Music" }),
    awful.key({}, "XF86AudioNext",
            function()
                awful.spawn({"playerctl", "next"})
            end,
        { description = "Playerctl Next", group = "Music" }),
    awful.key({ctrl}, "XF86AudioNext",
            function()
                awful.spawn({"mpc", "next"})
            end,
        { description = "Playerctl Next", group = "Music" }),
    awful.key({ ctrl }, "XF86AudioPrev",
            function()
                awful.spawn({"mpc", "prev"})
            end,
        { description = "Playerctl Next", group = "Music" }),
    awful.key({ ctrl }, "XF86AudioPlay",
            function()
                awful.spawn({"mpc", "toggle"})
            end,
        { description = "Playerctl Next", group = "Music" }),

    -- Scrots
    awful.key({}, "Print",
            function()
                awful.spawn({"flameshot", "full"})
            end,
        { description = "Take a Full Screenshot", group = "Scrots" }),
    awful.key({ shift }, "Print",
            function()
                awful.spawn({"flameshot", "gui"})
            end,
        { description = "Take a Partial Screenshot", group = "Scrots" }),
    awful.key({ alt }, "Print",
            function()
                awful.spawn({"flameshot", "full", "-d 5000"})
            end,
        { description = "Take a Delayed Screenshot", group = "Scrots" }),
})

-- Mouse Bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () awemenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, awful.button.names.LEFT,
            function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, awful.button.names.LEFT,
            function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, awful.button.names.RIGHT,
            function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

-- Client Bindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "Down",
            function()
                awful.client.focus.bydirection("down")
            end,
        { description = "focus down", group = "client" }),
    awful.key({ modkey }, "Up",
            function()
                awful.client.focus.bydirection("up")
            end,
        { description = "focus up", group = "client" }),
    awful.key({ modkey }, "Left",
            function()
                awful.client.focus.bydirection("left")
            end,
        { description = "focus left", group = "client" }),
    awful.key({ modkey }, "Right",
            function()
                awful.client.focus.bydirection("right")
            end,
        { description = "focus right", group = "client" }),
    awful.key({ modkey }, "j",
            function()
                awful.client.focus.byidx(1)
            end,
        { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k",
            function()
                awful.client.focus.byidx(-1)
            end,
        { description = "focus previous by index", group = "client" }),
    awful.key({ modkey, shift }, "j",
            function()
                awful.client.swap.byidx(1)
            end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, shift }, "k",
            function()
                awful.client.swap.byidx(-1)
            end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey }, "Tab", 
            function ()
                awful.client.focus.byidx(1)
            end,
        { description = "Focus Next by Index", group = "Client" }),
    awful.key({ modkey, shift }, "Tab",
            function ()
                awful.client.focus.byidx(-1)
            end,
        { description = "Focus Previous by Index", group = "Client" }),
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "Only View Tag",
        group       = "Tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers = { modkey, shift },
        keygroup    = "numrow",
        description = "Move Focused Client to Tag",
        group       = "Tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                    tag:view_only()
                end
            end
        end,
    },
})

-- Client Options Bindings
client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey }, "g",
            function (c)
                c.x = (c.screen.geometry.width - c.width) / 2
                c.y = (c.screen.geometry.height - c.height) / 2
            end,
            { description = "Center Client", group = "Client" }),
        awful.key({ modkey, shift }, "f",
                function (c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
            { description = "Toggle Fullscreen", group = "Client" }),
        awful.key({ modkey }, "q",
                function (c) 
                    c:kill()   
                end,
            { description = "close", group = "Client" }),
        awful.key({ modkey, shift }, "t",
                awful.client.floating.toggle,
            { description = "Toggle Floating", group = "Client" }),
        awful.key({ modkey, ctrl }, "Return",
                function (c) 
                    c:swap(awful.client.getmaster()) 
                end,
            { description = "Move to Master", group = "Client" }),
        awful.key({ modkey }, "o",
                function (c)
                    c:move_to_screen()     
                end,
            { description = "Move to Screen", group = "Client" }),
        awful.key({ modkey }, "t",
                function (c)
                    c.ontop = not c.ontop
                end,
            { description = "Toggle Keep on Top", group = "Client" }),
        awful.key({ modkey }, "n",
                function (c)
                    c.minimized = true
                end ,
            { description = "Minimize", group = "Client" }),
        awful.key({ modkey }, "m",
                function (c)
                    c.maximized = not c.maximized
                    c:raise()
                end ,
            { description = "(Un)Maximize", group = "Client" }),
        awful.key({ modkey, ctrl }, "m",
                function (c)
                    c.maximized_vertical = not c.maximized_vertical
                    c:raise()
                end ,
           { description = "(Un)Maximize Vertically", group = "Client" }),
        awful.key({ modkey, shift }, "m",
                function (c)
                    c.maximized_horizontal = not c.maximized_horizontal
                    c:raise()
                end ,
            { description = "(Un)Maximize Horizontally", group = "Client" }),
    })
end)

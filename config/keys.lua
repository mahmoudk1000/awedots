local awful = require("awful")
local gears = require("gears")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () awemenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,         }, "F1",
            hotkeys_popup.show_help,
        {description="Show Help", group="Awesome"}),
    awful.key({ modkey, alt     }, "r",
            awesome.restart,
        {description = "Reload Awesome", group = "Awesome"}),
    awful.key({ modkey, shift   }, "q",
            awesome.quit,
        {description = "Quit Awesome", group = "Awesome"}),
    awful.key({ modkey,         }, "Return",
            function () awful.spawn(terminal) end,
        {description = "Open Terminal", group = "Launcher"}),
    awful.key({ modkey,         }, "r",
            function () awful.screen.focused().mypromptbox:run() end,
        {description = "Run Prompt", group = "Launcher"}),
    awful.key({modkey,          }, "d",
           function() awful.spawn(rofi) end,
        {description = "Launch Rofi", group = "Launcher"}),
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,         }, "c",
            awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({ modkey,         }, "v",
            awful.tag.viewnext,
        {description = "view next", group = "tag"}),
    awful.key({ modkey,         }, "Escape",
            awful.tag.history.restore,
        {description = "go back", group = "tag"}),
})

awful.keyboard.append_global_keybindings({
    awful.key({modkey,          }, "w",
            function() awful.spawn(browser) end,
        {description = "Launch Browser", group = "Launcher"}),
    awful.key({modkey,          }, "f",
            function() awful.spawn(filemanager) end,
        {description = "Launch Filemanager", group = "Launcher"}),
    awful.key({modkey,          }, "o",
            function() awful.spawn(obsidian) end,
        {description = "Launch Obsidian", group = "Launcher"}),
    awful.key({modkey,          }, "p",
            function() awful.spawn.easy_async_with_shell("poww") end,
        {description = "Launch Power Menu", group = "Launcher"}),
    awful.key({modkey,          }, "b",
            function() awful.spawn.easy_async_with_shell("blum") end,
        {description = "Launch Bluetooth Menu", group = "Launcher"}),
})

awful.keyboard.append_global_keybindings({
    -- Volume control
    awful.key({}, "XF86AudioRaiseVolume",
            function() awful.spawn("pamixer -i 5") end,
        {description = "increase volume", group = "awesome"}),
    awful.key({}, "XF86AudioLowerVolume",
            function() awful.spawn("pamixer -d 5") end,
        {description = "decrease volume", group = "awesome"}),
    awful.key({}, "XF86AudioMute",
            function() awful.spawn("pamixer --toggle-mute") end,
        {description = "mute volume", group = "awesome"}), -- Media Control
    awful.key({}, "XF86AudioPlay",
            function() awful.spawn("playerctl play-pause") end,
        {description = "toggle playerctl", group = "awesome"}),
    awful.key({}, "XF86AudioPrev",
            function() awful.spawn("playerctl previous") end,
        {description = "playerctl previous", group = "awesome"}),
    awful.key({}, "XF86AudioNext",
            function() awful.spawn("playerctl next") end,
        {description = "playerctl next", group = "awesome"}),

    -- Screen Shots/Vids
    awful.key({}, "Print",
            function() awful.spawn.easy_async_with_shell("flameshot") end,
        {description = "take a full screenshot", group = "awesome"}),
    awful.key({}, "Print",
            function() awful.spawn.easy_async_with_shell("flameshot gui") end,
        {description = "take a partial screenshot", group = "awesome"}),
    awful.key({}, "Print",
            function() awful.spawn.easy_async_with_shell("flameshot full -d 5000") end,
        {description = "take a full screenshot", group = "awesome"}),
    
    -- Brightness
    awful.key({}, "XF86MonBrightnessUp",
            function() awful.spawn("light -A 10") end,
        {description = "increase brightness", group = "awesome"}),
    awful.key({}, "XF86MonBrightnessDown",
            function() awful.spawn("light -U 10") end,
        {description = "decrease brightness", group = "awesome"}),
})

awful.keyboard.append_global_keybindings({
    awful.key(
            { modkey }, "Tab", function () awful.client.focus.byidx(1) end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key(
            { modkey, shift }, "Tab", function () awful.client.focus.byidx(-1) end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
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
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
	            tag:view_only()
                end
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1,
            function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1,
            function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3,
            function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
                function (c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
            {description = "toggle fullscreen", group = "Client"}),
        awful.key({ modkey,   }, "q",
                function (c)    c:kill()   end,
            {description = "close", group = "Client"}),
        awful.key({ modkey, shift }, "t",
                awful.client.floating.toggle,
            {description = "toggle floating", group = "Client"}),
        awful.key({ modkey, ctrl }, "Return",
                function (c) c:swap(awful.client.getmaster()) end,
            {description = "move to master", group = "Client"}),
        awful.key({ modkey,           }, "o",
                function (c)    c:move_to_screen()     end,
            {description = "move to screen", group = "Client"}),
        awful.key({ modkey,           }, "t",
                function (c) c.ontop = not c.ontop            end,
            {description = "toggle keep on top", group = "Client"}),
        awful.key({ modkey,           }, "n",
                function (c)
                    c.minimized = true
                end ,
            {description = "minimize", group = "Client"}),
        awful.key({ modkey,           }, "m",
                function (c)
                    c.maximized = not c.maximized
                    c:raise()
                end ,
            {description = "(un)maximize", group = "Client"}),
        awful.key({ modkey,      ctrl }, "m",
                function (c)
                    c.maximized_vertical = not c.maximized_vertical
                    c:raise()
                end ,
           {description = "(un)maximize vertically", group = "Client"}),
        awful.key({ modkey,     shift }, "m",
                function (c)
                    c.maximized_horizontal = not c.maximized_horizontal
                    c:raise()
                end ,
            {description = "(un)maximize horizontally", group = "Client"}),
    })
end)

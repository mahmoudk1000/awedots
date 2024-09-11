local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local function createElements()
    local elems = wibox.widget({
        layout = wibox.layout.fixed.horizontal,
        spacing = 20,
        id = "switcher",
    })

    local current = 1

    local function updateElements(action)
        action = action or ""
        elems:reset()

        local clients = client.get()
        local sortedClients = {}

        if client.focus then
            table.insert(sortedClients, client.focus)
        end

        for _, c in ipairs(clients) do
            if c ~= sortedClients[1] then
                table.insert(sortedClients, c)
            end
        end

        for _, c in ipairs(sortedClients) do
            local widget = wibox.widget({
                {
                    {
                        {
                            id = "icon",
                            forced_height = 70,
                            halign = "center",
                            forced_width = 70,
                            image = c.icon,
                            widget = wibox.widget.imagebox,
                        },
                        {
                            {
                                id = "name",
                                halign = "center",
                                text = c.name or "Unnamed",
                                widget = wibox.widget.textbox,
                            },
                            widget = wibox.container.constraint,
                            width = 100,
                            height = 18,
                        },
                        spacing = dpi(5),
                        layout = wibox.layout.fixed.vertical,
                    },
                    margins = dpi(20),
					widget = wibox.container.margin,
                },
				bg = beautiful.bg,
				forced_width = dpi(130),
                forced_height = dpi(135),
                shape = helpers:rrect(),
				widget = wibox.container.background,
            })
            elems:add(widget)
        end

        if action == "next" then
            current = (current >= #sortedClients) and 1 or current + 1
        end

        for i, element in ipairs(elems.children) do
            element.bg = (i == current) and beautiful.xcolor8 or beautiful.xbackground
        end

        if action == "raise" then
            local c = sortedClients[current]
            if c then
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                c:emit_signal("request::activate")
                c:raise()
            end
            current = 0
        end

        return elems
    end

    elems = updateElements()

    return elems, updateElements
end

local function winswitch(s)
    local winlist, updateElements = createElements()

    local container = awful.popup({
		screen = s,
        ontop = true,
        visible = false,
        stretch = false,
		bg = beautiful.bg,
        shape = helpers:rrect(),
        placement = awful.placement.centered,
		widget = wibox.container.background,
    })

    container:setup({
        {
			winlist,
            margins = dpi(10),
			widget = wibox.container.margin,
        },
        layout = wibox.layout.fixed.vertical,
    })

    local function showSwitcher()
        container.visible = true
        updateElements()
    end

    local function hideSwitcher()
        updateElements("raise")
        container.visible = false
    end

    local keygrabber
    keygrabber = awful.keygrabber({
        start_callback = showSwitcher,
        stop_callback = function()
            hideSwitcher()
        end,
        keybindings = {
            {
                { "Mod4" },
                "Tab",
                function()
                    updateElements("next")
                end,
                { description = "Switch to next window", group = "client" },
            },
        },
        stop_key = "Mod4",
        stop_event = "release",
        export_keybindings = true,
        stop_on_event = true,
    })

    awful.keyboard.append_global_keybindings({
        awful.key({ "Mod4" }, "Tab", function()
            if not keygrabber.is_running then
                keygrabber:start()
            end
        end, { description = "Open window switcher", group = "client" })
    })
end

awful.screen.connect_for_each_screen(winswitch)

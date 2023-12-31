local awful             = require("awful")
local gears             = require "gears"
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local res_path          = gears.filesystem.get_configuration_dir() .. "theme/res/"
local recolor           = gears.color.recolor_image

local volume_stuff      = require("signal.volume")
local battery_stuff     = require("signal.battery")
local bluetooth_stuff   = require("signal.bluetooth")


-- Taglist Widget
local taglist = function(s)
    local taglist_buttons = awful.util.table.join(
        awful.button({ }, awful.button.names.LEFT, function(t) t:view_only() end),
        awful.button({ modkey }, awful.button.names.LEFT, function(t)
            if c.focus then
                c.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, awful.button.names.RIGHT, awful.tag.viewtoggle),
        awful.button({ modkey }, awful.button.names.RIGHT, function(t)
            if c.focus then
                c.focus:toggle_tag(t)
            end
        end),
        awful.button({ }, awful.button.names.SCROLL_UP, function(t) awful.tag.viewprev(t.screen) end),
        awful.button({ }, awful.button.names.SCROLL_DOWN, function(t) awful.tag.viewnext(t.screen) end)
    )

    local cool_tags = function(self, c3, _)
        if c3.selected then
            self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor4
            self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                gears.shape.rounded_bar(cr, dpi(20), dpi(8))
            end
        elseif #c3:clients() == 0 then
            self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor0
            self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                gears.shape.rounded_bar(cr, dpi(12), dpi(8))
            end
        else
            self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor8
            self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                gears.shape.rounded_bar(cr, dpi(15), dpi(8))
            end
        end
    end


    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = {
            spacing = dpi(8),
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = "index_role",
                        widget = wibox.widget.textbox,
                    },
                    margins = dpi(10),
                    widget  = wibox.container.margin,
                },
                id      = "index_icon",
                shape   = function(cr, _)
                    gears.shape.circle(cr, dpi(8), dpi(8))
                end,
                widget  = wibox.container.background
            },
            id = "background_role",
            create_callback = cool_tags,
            update_callback = cool_tags,
            layout = wibox.container.background
        },
        buttons = taglist_buttons
    }
end


-- LayoutBox Widget
local layoutbox = awful.widget.layoutbox {
    screen = s,
    -- Add buttons, allowing you to change the layout
    buttons = {
        awful.button({ }, awful.button.names.LEFT, function () awful.layout.inc( 1) end),
        awful.button({ }, awful.button.names.RIGHT, function () awful.layout.inc(-1) end),
        awful.button({ }, awful.button.names.SCROLL_UP, function () awful.layout.inc( 1) end),
        awful.button({ }, awful.button.names.SCROLL_DOWN, function () awful.layout.inc(-1) end),
    }
}


-- Clock Widget
local clock = wibox.widget {
    {
        {
            image           = recolor(res_path .. "clock.png", beautiful.xcolor2),
            valign          = "center",
            align           = "center",
            forced_height   = dpi(15),
            widget          = wibox.widget.imagebox
        },
        margins = { right = dpi(5) },
        layout  = wibox.container.margin
    },
    {
        format  = "%a %d %b, ",
        font    = beautiful.font,
        valign  = "center",
        align   = "center",
        widget  = wibox.widget.textclock
    },
    {
        format  = "%R",
        font    = beautiful.font_bold,
        align   = "center",
        valign  = "center",
        widget  = wibox.widget.textclock
    },
    layout = wibox.layout.fixed.horizontal,
    buttons = gears.table.join(awful.button({}, awful.button.names.LEFT, nil, function()
        awesome.emit_signal("clock::clicked")
    end))
}


-- Volume Widget
local volume = wibox.widget {
    {
        {
            id              = "icon",
            image           = recolor(res_path .. "volume.png", beautiful.xcolor3),
            align           = "center",
            valign          = "center",
            forced_height   = dpi(15),
            widget          = wibox.widget.imagebox
        },
        margins = { right =  dpi(5) },
        layout  = wibox.container.margin
    },
    {
        id      = "text",
        text    = "100%",
        font    = beautiful.font,
        align   = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal,
}

awesome.connect_signal("volume::value", function(value, icon)
    volume:get_children_by_id("text")[1]:set_text(value .. "%")
    volume:get_children_by_id("icon")[1]:set_image(icon)
    awesome.emit_signal("widget::redraw_needed")
end)


-- Backlight Widget
local backlight = wibox.widget {
    {
        {
            image           = recolor(res_path .. "lamp.png", beautiful.xcolor2),
            align           = "center",
            valign          = "center",
            forced_height   = dpi(15),
            widget          = wibox.widget.imagebox
        },
        margins = { right =  dpi(5) },
        layout  = wibox.container.margin
    },
    {
        id      = "text",
        text    = "100%",
        align   = "center",
        valign  = "center",
        font    = beautiful.font,
        widget  = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal,
}

awesome.connect_signal("brightness::value", function(value)
    backlight:get_children_by_id("text")[1]:set_text(value .. "%")
    awesome.emit_signal("widget::redraw_needed")
end)


-- Bluetooth Widget
local bluetooth = wibox.widget {
    {
        {
            id              = "icon",
            markup          = recolor(res_path .. "blue-on.png", beautiful.xcolor4),
            align           = "center",
            valign          = "center",
            forced_height   = dpi(15),
            widget          = wibox.widget.imagebox
        },
        margins = { right = dpi(5) },
        layout  = wibox.container.margin
    },
    {
        id      = "text",
        text    = "On",
        align   = "center",
        valign  = "center",
        font    = beautiful.font,
        widget  = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal,
}

awesome.connect_signal("bluetooth::status", function(is_powerd, _, icon)
    bluetooth:get_children_by_id("text")[1]:set_text(is_powerd)
    bluetooth:get_children_by_id("icon")[1]:set_image(icon)
end)

gears.timer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = function()
        bluetooth_stuff:emit_bluetooth_info()
        volume_stuff:emit_volume_state()
    end
})


-- Battery Widget
local battery = wibox.widget {
    {
        {
            id              = "icon",
            image           = recolor(res_path .. "bat-nor.png", beautiful.xcolor5),
            align           = "center",
            valign          = "center",
            forced_height   = dpi(15),
            widget          = wibox.widget.imagebox
        },
        margins = { right = dpi(5) },
        layout  = wibox.container.margin
    },
    {
        id      = "text",
        text    = "100%",
        align   = "center",
        valign  = "center",
        font    = beautiful.font,
        widget  = wibox.widget.textbox
    },
    layout = wibox.layout.fixed.horizontal,
}

awesome.connect_signal("battery::info", function(value, icon)
    battery:get_children_by_id("text")[1]:set_text(value .. "%")
    battery:get_children_by_id("icon")[1]:set_image(icon)
    awesome.emit_signal("widget::redraw_needed")
end)

gears.timer({
    timeout = 30,
    autostart = true,
    call_now = true,
    callback = function()
        battery_stuff:emit_battery_info()
    end
})


-- Bar
local function init_bar(s)
    local bar = awful.wibar {
        screen      = s,
        position    = "bottom",
        type        = "dock",
        visible     = true,
        ontop       = false,
        height      = dpi(30),
        width       = s.geometry.width
    }
    bar:struts { left = dpi(0), right = dpi(0), top = dpi(0), bottom = dpi(30) }
    bar:setup {
        {
            -- Left Widgets
            {
                layoutbox,
                margins = { left = dpi(10), right = dpi(9), top = dpi(9), bottom = dpi(9) },
                widget = wibox.container.margin
            },
            {
                taglist(s),
                margins = { left = dpi(8), right = dpi(8), top = dpi(12), bottom = dpi(10) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.fixed.horizontal,
        },
        {
            -- Middle Widget
            clock,
            layout = wibox.container.place
        },
        {
            -- Right Widgets
            {
                volume,
                margins = dpi(8),
                layout = wibox.container.margin
            },
            {
                backlight,
                margins = dpi(8),
                layout = wibox.container.margin
            },
            {
                bluetooth,
                margins = dpi(8),
                layout = wibox.container.margin
            },
            {
                battery,
                margins = { left = dpi(8), right = dpi(10), top = dpi(8), bottom = dpi(8) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.align.horizontal
    }
end

awful.screen.connect_for_each_screen(function(s)
    init_bar(s)
end)

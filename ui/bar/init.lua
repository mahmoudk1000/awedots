local awful             = require("awful")
local gears             = require "gears"
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi
local battery_stuff     = require("signal.battery")
local volume_stuff      = require("signal.volume")
local backlight_stuff   = require("signal.backlight")
local bluetooth_stuff   = require("signal.bluetooth")


-- Taglist Widget
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local taglist = function(s)
    return awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        layout = wibox.layout.fixed.horizontal,
        widget_template = {
            {
                {
                    {
                        {
                            id = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                        margins = {top = dpi(4), bottom = dpi(4)},
                        widget = wibox.container.margin,
                    },
                    id = 'background_role',
                    widget = wibox.container.background,
                },
                margins = {left = dpi(8), right = dpi(8), top = dpi(4), bottom = dpi(4)},
                widget = wibox.container.margin,
            },
            id = 'wrapper_role',
            widget = wibox.container.background,
            spacing = dpi(3),
        },
        buttons = taglist_buttons,
    }
end


-- LayoutBox Widget
local layoutbox = awful.widget.layoutbox {
    screen = s,
    -- Add buttons, allowing you to change the layout
    buttons = {
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end),
    }
}


-- Clock Widget
local clock = wibox.widget {
    {
        markup = "<span foreground='" .. beautiful.xcolor2 .. "'>󱑂  </span>",
        font = beautiful.iconfont,
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox,
    },
    {
        format = "%b %d,",
        font = beautiful.font,
        valign = "center",
        align = "center",
        widget = wibox.widget.textclock,
    },
    {
        format = "%R",
        font = beautiful.font_bold,
        align = "center",
        valign = "center",
        widget = wibox.widget.textclock,
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(3),
}


-- Volume Widget
local volume = wibox.widget {
    {
        id = "icon",
        markup = "<span foreground='" .. beautiful.xcolor3 .. "'>" .. volume_stuff.volume_icon() .. "</span>",
        font = beautiful.iconfont,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    },
    {
        margins = {left = dpi(5), right = dpi(5)},
        widget = wibox.container.margin,
        {
            id = "text",
            text = volume_stuff.get_volume() .. "%",
            font = font,
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_volume()
    local icon = "<span foreground='" .. beautiful.xcolor3 .. "'>" .. volume_stuff.volume_icon() .. "</span>"
    local value = volume_stuff.get_volume() .. "%"

    volume:get_children_by_id("icon")[1]:set_markup(icon)
    volume:get_children_by_id("text")[1]:set_text(value)
end

awesome.connect_signal("volume::update", function()
    update_volume()
    volume:emit_signal("widget::redraw_needed")
end)


-- Backlight Widget
local backlight = wibox.widget {
    {
        markup = "<span foreground='" .. beautiful.xcolor2 .. "'>󰌵 </span>",
        font = beautiful.iconfont,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    },
    {
        margins = {left = dpi(5), right = dpi(5)},
        widget = wibox.container.margin,
        {
            id = "text",
            text = backlight_stuff.get_backlight() .. "%",
            align = "center",
            valign = "center",
            font = font,
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_backlight()
    local value = backlight_stuff.get_backlight() .. "%"

    backlight:get_children_by_id("text")[1]:set_text(value)
end

awesome.connect_signal("backlight::update", function()
    update_backlight()
    backlight:emit_signal("widget::redraw_needed")
end)


-- Bluetooth Widget
local bluetooth = wibox.widget {
    {
        id = "icon",
        markup = "<span foreground='" .. beautiful.xcolor4 .. "'>" .. bluetooth_stuff.bluetooth_icon() .. "</span>",
        font = beautiful.iconfont,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    },
    {
        margins = {left = dpi(5), right = dpi(5)},
        widget = wibox.container.margin,
        {
            id = "text",
            text = bluetooth_stuff.get_status(),
            align = "center",
            valign = "center",
            font = font,
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_bluetooth()
    local icon = "<span foreground='" .. beautiful.xcolor6 .. "'>" .. bluetooth_stuff.bluetooth_icon() .. "</span>"
    local value = bluetooth_stuff.get_status()

    bluetooth:get_children_by_id("icon")[1]:set_markup(icon)
    bluetooth:get_children_by_id("text")[1]:set_text(value)
end

gears.timer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = update_bluetooth,
})


-- Battery Widget
local battery_color, battery_icon = battery_stuff.battery_icon()
local battery = wibox.widget {
    {
        id = "icon",
        markup = "<span foreground='" .. battery_color .. "'>" .. battery_icon .. "</span>",
        font = beautiful.iconfont,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    },
    {
        margins = {left = dpi(5), right = dpi(5)},
        widget = wibox.container.margin,
        {
            id = "text",
            text = battery_stuff.get_battery_percent() .. "%",
            align = "center",
            valign = "center",
            font = font,
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_battery()
    local battery_color, battery_icon = battery_stuff.battery_icon()
    local icon = "<span foreground='" .. battery_color .. "'>" .. battery_icon .. "</span>"
    local value = battery_stuff.get_battery_percent() .. "%"

    battery:get_children_by_id("icon")[1]:set_markup(icon)
    battery:get_children_by_id("text")[1]:set_text(value)
end

gears.timer({
    timeout = 30,
    autostart = true,
    call_now = true,
    callback = update_battery,
})


-- Bar
local function make_bar(s)
    local bar = wibox({
        visible = true,
        ontop = false,
        position = "bottom",
        type = 'dock',
        screen = s,
        width = s.geometry.width,
        height = dpi(30),
    })
    bar:struts { bottom = dpi(0), top = dpi(30), left = dpi(0), right = dpi(0) }
    bar:setup {
        layout = wibox.layout.align.horizontal,
        { 
            -- Left Widgets
            layout = wibox.layout.fixed.horizontal,
            {
                layoutbox,
                margins = {left = dpi(10), right = dpi(10), top = dpi(8), bottom = dpi(8)},
                widget = wibox.container.margin,
            },
            taglist(s),
        },
        {
            -- Middle Widget
            layout = wibox.container.place,
            clock,
        },
        { 
            -- Right Widgets
            layout = wibox.layout.fixed.horizontal,
            {
                volume,
                margins = {left = dpi(10), right = dpi(10)},
                widget = wibox.container.margin,
            },
            {
                backlight,
                margins = {right = dpi(10)},
                widget = wibox.container.margin,
            },
            bluetooth,
            {
                battery,
                margins = {left = dpi(10), right = dpi(10)},
                widget = wibox.container.margin,
            },
        },
    }
end

awful.screen.connect_for_each_screen(function(s)
    make_bar(s)
end)

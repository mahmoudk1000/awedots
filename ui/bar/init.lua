local awful             = require("awful")
local gears             = require "gears"
local wibox             = require("wibox")
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi

local helpers           = require("helpers")
local battery_stuff     = require("signal.battery")
local volume_stuff      = require("signal.volume")
local backlight_stuff   = require("signal.backlight")
local bluetooth_stuff   = require("signal.bluetooth")


-- Taglist Widget
local taglist = function(s)
    local taglist_buttons = awful.util.table.join(
        awful.button({ }, awful.button.names.LEFT, function(t) t:view_only() end),
        awful.button({ modkey }, awful.button.names.LEFT, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, awful.button.names.RIGHT, awful.tag.viewtoggle),
        awful.button({ modkey }, awful.button.names.RIGHT, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({ }, awful.button.names.SCROLL_UP, function(t) awful.tag.viewprev(t.screen) end),
        awful.button({ }, awful.button.names.SCROLL_DOWN, function(t) awful.tag.viewnext(t.screen) end)
    )

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
                    margins = dpi(8),
                    widget  = wibox.container.margin,
                },
                id      = "index_icon",
                shape   = function(cr, w, h)
                    gears.shape.circle(cr, dpi(8), dpi(8))
                end,
                widget  = wibox.container.background
            },
            id = "background_role",
            layout = wibox.container.background,
            create_callback = function(self, c3, _)
                if c3.selected then
                    self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor4
                    self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                        gears.shape.rounded_bar(cr, dpi(12), dpi(8))
                    end
                elseif #c3:clients() == 0 then
                    self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor0
                    self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                        gears.shape.circle(cr, dpi(8), dpi(8))
                    end
                else
                    self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor8
                    self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                        gears.shape.circle(cr, dpi(8), dpi(8))
                    end
                end
            end,
            update_callback = function(self, c3, _)
                if c3.selected then
                    self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor4
                    self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                        gears.shape.rounded_bar(cr, dpi(12), dpi(8))
                    end
                elseif #c3:clients() == 0 then
                    self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor0
                    self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                        gears.shape.circle(cr, dpi(8), dpi(8))
                    end
                else
                    self:get_children_by_id("index_icon")[1].bg = beautiful.xcolor8
                    self:get_children_by_id("index_icon")[1].shape = function(cr, w, h)
                        gears.shape.circle(cr, dpi(8), dpi(8))
                    end
                end
            end
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
        markup = helpers:color_markup("󱑂  ", beautiful.xcolor2),
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

-- Calendar Widget Signal
clock:buttons(
    gears.table.join(
        awful.button({},  awful.button.names.LEFT , nil, function()
            awesome.emit_signal("clock::clicked")
        end)
    )
)


-- Volume Widget
local volume = wibox.widget {
    {
        id = "icon",
        markup = helpers:color_markup(volume_stuff:volume_icon(), beautiful.xcolor3),
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
            text = "100%",
            font = beautiful.font,
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_volume()
    local icon = helpers:color_markup(volume_stuff:volume_icon(), beautiful.xcolor3)
    local value = volume_stuff:get_volume() .. "%"

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
        markup = helpers:color_markup("󰌵 ", beautiful.xcolor2),
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
            text = backlight_stuff:get_backlight() .. "%",
            align = "center",
            valign = "center",
            font = font,
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_backlight()
    local value = backlight_stuff:get_backlight() .. "%"

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
        markup = helpers:color_markup(bluetooth_stuff:bluetooth_icon(), beautiful.xcolor6),
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
            text = bluetooth_stuff:get_status(),
            align = "center",
            valign = "center",
            font = font,
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_bluetooth()
    local icon = helpers:color_markup(bluetooth_stuff:bluetooth_icon(), beautiful.xcolor6)
    local value = bluetooth_stuff:get_status()

    bluetooth:get_children_by_id("icon")[1]:set_markup(icon)
    bluetooth:get_children_by_id("text")[1]:set_text(value)
end

gears.timer({
    timeout = 5,
    autostart = true,
    call_now = true,
    callback = update_bluetooth
})


-- Battery Widget
local battery_color, battery_icon = battery_stuff:battery_icon()
local battery = wibox.widget {
    {
        id = "icon",
        markup = helpers:color_markup(battery_icon, battery_color),
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
            text = battery_stuff:get_battery_percent() .. "%",
            align = "center",
            valign = "center",
            font = font,
            widget = wibox.widget.textbox,
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

function update_battery()
    local battery_color, battery_icon = battery_stuff:battery_icon()
    local icon = helpers:color_markup(battery_icon, battery_color)
    local value = battery_stuff:get_battery_percent() .. "%"

    battery:get_children_by_id("icon")[1]:set_markup(icon)
    battery:get_children_by_id("text")[1]:set_text(value)
end

gears.timer({
    timeout = 30,
    autostart = true,
    call_now = true,
    callback = update_battery
})


-- Bar
local function make_bar(s)
    local bar = wibox({
        screen      = s,
        position    = "top",
        type        = "dock",
        visible     = true,
        ontop       = false,
        height      = dpi(30),
        width       = s.geometry.width,
    })
    bar:struts { bottom = dpi(0), top = dpi(30), left = dpi(0), right = dpi(0) }
    bar:setup {
        layout = wibox.layout.align.horizontal,
        { 
            -- Left Widgets
            layout = wibox.layout.fixed.horizontal,
            {
                layoutbox,
                margins = { left = dpi(10), right = dpi(10), top = dpi(8), bottom = dpi(8) },
                widget = wibox.container.margin,
            },
            {
                taglist(s),
                margins = { left = dpi(8), right = dpi(8), top = dpi(12), bottom = dpi(9) },
                layout = wibox.container.margin
            },
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
                margins = { left = dpi(10), right = dpi(10) },
                widget = wibox.container.margin,
            },
            {
                backlight,
                margins = { right = dpi(10) },
                widget = wibox.container.margin,
            },
            bluetooth,
            {
                battery,
                margins = { left = dpi(10), right = dpi(10) },
                widget = wibox.container.margin,
            },
        },
    }
end

awful.screen.connect_for_each_screen(function(s)
    make_bar(s)
end)

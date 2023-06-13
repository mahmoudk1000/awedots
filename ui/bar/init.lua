local awful = require("awful")
local gears = require "gears"
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


-- Define icons for taglist status
local icon_focused = ""
local icon_occupy = ""
local icon_empty = ""

-- Create taglist widget
local taglist = wibox.widget {
    widget = wibox.layout.fixed.horizontal,
    spacing = dpi(2)
}

-- Add tags to taglist widget
for i, tag in ipairs(awful.screen.focused().tags) do
    local tag_icon = wibox.widget {
        font = beautiful.font,
        align = "center",
        valign = "center",
        forced_width = 20,
        forced_height = 10,
        widget = wibox.widget.textbox,
    }
    -- Set icon based on tag status
    if tag.selected then
        tag_icon.text = icon_focused
        tag_icon.markup = "<span color='" .. beautiful.xcolor6 .. "'>" .. icon_focused .. "</span>"
    elseif #tag:clients() > 0 then
        tag_icon.text = icon_occupy
        tag_icon.markup = "<span color='" .. beautiful.xcolor3 .. "'>" .. icon_focused .. "</span>"
    else
        tag_icon.text = icon_empty
        tag_icon.markup = "<span color='" .. beautiful.xcolor0 .. "'>" .. icon_focused .. "</span>"
    end

    -- Add tag icon to taglist widget
    taglist:add(tag_icon)

    -- Add click event to tag icon
    tag_icon:connect_signal("button::press", function()
        tag:view_only()
    end)
end


local clock = wibox.widget {
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

function get_volume()
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()

    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume))
    
    return volume
end

local volume = wibox.widget {
    {
        markup = "<span foreground='" .. beautiful.xcolor4 .. "'>󱄠 </span>",
        font = beautiful.iconfont,
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox,
    },
    {
        widget = wibox.container.margin,
        left = 5,
        right = 5,
        {
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = font,
            text = get_volume(),
        },
    },
    layout = wibox.layout.fixed.horizontal,
}

awful.widget.watch(get_volume, 1, function(widget, stdout)
    widget:get_children_by_id("text")[1].text = stdout
end, volume_widget)


local bluetooth_widget = wibox.widget {
    {
        image = bluetooth_icon,
        widget = wibox.widget.imagebox,
    },
    {
        widget = wibox.widget.textbox,
        text = "Connected",
        fg = bluetooth_color,
    },
    layout = wibox.layout.fixed.horizontal,
}

local backlight_widget = wibox.widget {
    {
        image = backlight_icon,
        widget = wibox.widget.imagebox,
    },
    {
        widget = wibox.widget.textbox,
        text = "100%",
        fg = backlight_color,
    },
    layout = wibox.layout.fixed.horizontal,
}

local battery_widget = wibox.widget {
    {
        image = battery_icon,
        widget = wibox.widget.imagebox,
    },
    {
        widget = wibox.widget.textbox,
        text = "100%",
        fg = battery_color,
    },
    layout = wibox.layout.fixed.horizontal,
}

awful.screen.connect_for_each_screen(function(s)
    s.taglist = taglist
end)

local bar = wibox({
    type = "dock",
    position = "bottom",
    screen = s,
    height = dpi(30),
    width = dpi(1920),
    visible = true,
    ontop = false,
})

bar:struts { bottom = dpi(0), top = dpi(30), left = dpi(0), right = dpi(0) }
bar:setup {
    layout = wibox.layout.align.horizontal,
    { 
        -- Left widgets
        layout = wibox.layout.fixed.horizontal,
        {
            clock,
            margins = {left = dpi(10), right = dpi(15)},
            widget = wibox.container.margin
        },
        taglist,
    },
    nil, -- Middle widget
    { 
        -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        volume,
        bluetooth_widget,
        backlight_widget,
        battery_widget,
    },
}

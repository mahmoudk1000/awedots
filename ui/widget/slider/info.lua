local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi


local function cpu(vcpu)
    local pie = wibox.widget {
        value               = 1,
        max_value           = 1,
        height              = 120,
        width               = 120,
        background_color    = beautiful.xcolor8,
        color               = beautiful.xcolor5,
        margins             = dpi(10),
        shape               = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, 2 * math.pi)
        end,
        bar_shape           = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, math.rad(vcpu / 100 * 360))
        end,
        widget              = wibox.widget.progressbar
    }

    local percent = wibox.widget {
        markup  = vcpu .. "%",
        font    = beautiful.vont .. "Bold 10",
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local label = wibox.widget {
        markup  = "CPU",
        font    = beautiful.font,
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local cpu_widget = wibox.widget {
        {
            {
                {
                    pie,
                    direction = "east",
                    layout = wibox.container.rotate
                },
                percent,
                layout = wibox.layout.stack
            },
            {
                label,
                margins = { bottom = dpi(5) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical
        },
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        bg = beautiful.xcolor0,
        layout = wibox.container.background
    }

    return {
        widget = cpu_widget,
        update_value = function(new_value)
            pie.bar_shape = function(cr, w, h)
                gears.shape.arc(cr, w, h, nil, 0, math.rad(new_value / 100 * 360))
            end
            percent.markup = new_value .. "%"

            awesome.emit_signal("widget::redraw_needed")
        end
    }
end


local function ram(vram)
    local pie = wibox.widget {
        value               = 1,
        max_value           = 1,
        height              = 120,
        width               = 120,
        background_color    = beautiful.xbackground,
        color               = beautiful.xcolor3,
        margins             = dpi(10),
        shape               = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, 2 * math.pi)
        end,
        bar_shape           = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, math.rad(vram / 100 * 360))
        end,
        widget              = wibox.widget.progressbar
    }

    local percent = wibox.widget {
        markup  = vram .. "%",
        font    = beautiful.vont .. "Bold 10",
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local label = wibox.widget {
        markup  = "RAM",
        font    = beautiful.font,
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local ram_widget = wibox.widget {
        {
            {
                {
                    pie,
                    direction = "east",
                    layout = wibox.container.rotate
                },
                percent,
                layout = wibox.layout.stack
            },
            {
                label,
                margins = { bottom = dpi(5) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical
        },
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        bg = beautiful.xcolor0,
        layout = wibox.container.background
    }

    return {
        widget = ram_widget,
        update_value = function(new_value)
            pie.bar_shape = function(cr, w, h)
                gears.shape.arc(cr, w, h, nil, 0, math.rad(new_value / 100 * 360))
            end
            percent.markup = new_value .. "%"

            awesome.emit_signal("widget::redraw_needed")
        end
    }
end

local function hme(vhme)
    local pie = wibox.widget {
        value               = 1,
        max_value           = 1,
        height              = 120,
        width               = 120,
        background_color    = beautiful.xbackground,
        color               = beautiful.xcolor2,
        margins             = dpi(10),
        shape               = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, 2 * math.pi)
        end,
        bar_shape           = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, math.rad(vhme / 100 * 360))
        end,
        widget              = wibox.widget.progressbar
    }

    local percent = wibox.widget {
        markup  = vhme .. "%",
        font    = beautiful.vont .. "Bold 10",
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local label = wibox.widget {
        markup  = "HOME",
        font    = beautiful.font,
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local hme_widget = wibox.widget {
        {
            {
                {
                    pie,
                    direction = "east",
                    layout = wibox.container.rotate
                },
                percent,
                layout = wibox.layout.stack
            },
            {
                label,
                margins = { bottom = dpi(5) },
                layout = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical
        },
        shape = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        bg = beautiful.xcolor0,
        layout = wibox.container.background
    }

    return {
        widget = hme_widget,
        update_value = function(new_value)
            pie.bar_shape = function(cr, w, h)
                gears.shape.arc(cr, w, h, nil, 0, math.rad(new_value / 100 * 360))
            end
            percent.markup = new_value .. "%"

            awesome.emit_signal("widget::redraw_needed")
        end
    }
end

local cpuz = cpu(1)
local ramz = ram(1)
local home = hme(1)

awesome.connect_signal("sys::info", function(vcpu, vram, vhme)
    cpuz.update_value(vcpu)
    ramz.update_value(vram)
    home.update_value(vhme)
end)

return wibox.widget {
    {
        {
            cpuz,
            ramz,
            home,
            layout = wibox.layout.ratio.horizontal
        },
        shape   = function(cr, w, h)
             gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        bg      = beautiful.xcolor0,
        layout  = wibox.container.background
    },
    margins = dpi(10),
    layout = wibox.container.margin
}

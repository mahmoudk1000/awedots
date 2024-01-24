local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local rubato    = require("mods.rubato")

local dpi       = beautiful.xresources.apply_dpi


local function widget_template(name, value, color)
    local pie = wibox.widget {
        value               = value,
        height              = dpi(120),
        width               = dpi(120),
        background_color    = beautiful.xcolor8,
        color               = color,
        margins             = dpi(10),
        shape               = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, 2 * math.pi)
        end,
        bar_shape           = function(cr, w, h)
            gears.shape.arc(cr, w, h, nil, 0, math.rad(value * 3.6))
        end,
        widget              = wibox.widget.progressbar
    }

    local percent = wibox.widget {
        markup  = value .. "%",
        font    = beautiful.vont .. "Bold 10",
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local label = wibox.widget {
        markup  = name,
        font    = beautiful.font,
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.textbox
    }

    local widget = wibox.widget {
        {
            {
                {
                    pie,
                    direction   = "east",
                    layout      = wibox.container.rotate
                },
                percent,
                layout = wibox.layout.stack
            },
            {
                label,
                margins = { bottom = dpi(5) },
                layout  = wibox.container.margin
            },
            layout = wibox.layout.fixed.vertical
        },
        bg      = beautiful.xcolor0,
        shape   = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        layout  = wibox.container.background
    }

    return {
        widget = widget,
        update_value = function(new_value)
            local timed = rubato.timed {
                duration    = 0.8,
                pos         = math.rad(pie.value * 3.6) / math.rad(new_value * 3.6),
                subscribed  = function(pos)
                    pie.bar_shape = function(cr, w, h)
                        gears.shape.arc(cr, w, h, nil, 0, math.rad(new_value * 3.6 * pos))
                    end
                    percent.markup = math.floor(new_value * pos) .. "%"
                end
            }
            timed.target    = 1
            pie.value       = new_value
        end
    }
end

local cpu = widget_template("CPU", 1, beautiful.xcolor5)
local ram = widget_template("RAM", 1, beautiful.xcolor3)
local hme = widget_template("HOME", 1, beautiful.xcolor6)

awesome.connect_signal("sys::info", function(vcpu, vram, vhme)
    cpu.update_value(vcpu)
    ram.update_value(vram)
    hme.update_value(vhme)
end)

return wibox.widget {
    {
        {
            cpu,
            ram,
            hme,
            layout = wibox.layout.ratio.horizontal
        },
        bg      = beautiful.xcolor0,
        shape   = function(cr, w, h)
             gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        layout  = wibox.container.background
    },
    margins = dpi(10),
    layout  = wibox.container.margin
}

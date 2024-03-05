local awful             = require("awful")
local wibox             = require("wibox")
local gears             = require "gears"
local beautiful         = require("beautiful")
local dpi               = beautiful.xresources.apply_dpi


-- Calendar Styling
local styles = {}

styles.month   = {
    padding      = dpi(8),
    border_width = beautiful.border_width,
    bg_color     = beautiful.xbackground,
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
}
styles.normal  = {
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
}
styles.focus   = {
    fg_color = beautiful.xbackground,
    bg_color = beautiful.xcolor4,
    markup   = function(t) return '<b>' .. t .. '</b>' end,
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
}
styles.header  = {
    fg_color = beautiful.xforeground,
    font = beautiful.font_bold,
    markup   = function(t) return '<b>' .. t .. '</b>' end,
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
}
styles.weekday = {
    fg_color = beautiful.xcolor5,
    markup   = function(t) return '<b>' .. t .. '</b>' end,
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.border_radius)
    end,
}

local function decorate_cell(widget, flag, date)
    if flag == "monthheader" and not styles.monthheader then
        flag = "header"
    end

    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    -- Change bg color for weekends
    local d = { year = date.year, month = (date.month or 1), day = (date.day or 1)}
    local weekday = tonumber(os.date("%w", os.time(d)))
    local default_bg = (weekday==0) and beautiful.xcolor8 or beautiful.xcolor0
    local ret = wibox.widget {
        {
            widget,
            margins = (props.padding or dpi(7)) + (props.border_width or dpi(0)),
            widget  = wibox.container.margin
        },
        shape           = props.shape,
        border_color    = props.border_color or beautiful.border_normal,
        border_width    = props.border_width or 0,
        fg              = props.fg_color or beautiful.xforeground,
        bg              = props.bg_color or default_bg,
        widget          = wibox.container.background
    }
    return ret
end

return wibox.widget {
    {
        font            = beautiful.font,
        date            = os.date("*t"),
        spacing         = dpi(5),
        fn_embed        = decorate_cell,
        flex_height     = true,
        start_sunday    = true,
        widget          = wibox.widget.calendar.month
    },
    margins = dpi(10),
    layout = wibox.container.margin
}

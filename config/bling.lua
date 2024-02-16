local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local bling     = require("mods.bling")



bling.widget.tag_preview.enable {
    show_client_content = true,
    scale = 0.15,
    honor_padding = false,
    honor_workarea = false,
    placement_fn = function(c)
        awful.placement.bottom_left(c, {
            margins = {
                left = dpi(9),
                bottom = dpi(39)
            }
        })
    end,
    background_widget = wibox.widget {
        image = beautiful.wallpaper,
        horizontal_fit_policy = "fit",
        vertical_fit_policy   = "fit",
        widget = wibox.widget.imagebox
    }
}

bling.widget.window_switcher.enable {
    type = "thumbnail",
    hide_window_switcher_key = "Escape",
    minimize_key = "n",
    unminimize_key = "N",
    kill_client_key = "q",
    cycle_key = "Tab",
    previous_key = "Left",
    next_key = "Right",
    vim_previous_key = "h",
    vim_next_key = "l",
    cycleClientsByIdx = awful.client.focus.byidx,
    filterClients = awful.widget.tasklist.filter.currenttags
}

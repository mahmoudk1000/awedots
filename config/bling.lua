local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local bling     = require("mods.bling")



bling.widget.tag_preview.enable {
    show_client_content = true,
    scale = 0.15,
    honor_padding = true,
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

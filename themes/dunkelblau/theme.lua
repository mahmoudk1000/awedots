local theme_assets     = require("beautiful.theme_assets")
local xresources       = require("beautiful.xresources")
local dpi              = xresources.apply_dpi
local xrdb             = xresources.get_current_theme()
local gears            = require("gears")
local theme_path       = string.format("%s/.config/awesome/themes/%s/", os.getenv("HOME"), "dunkelblau")

local theme = {}

-- Load ~/.Xresources colors
theme.darker_bg       = "#0C1115"
theme.xbackground     = xrdb.background
theme.xforeground     = xrdb.foreground
theme.xcolor0         = xrdb.color0
theme.xcolor1         = xrdb.color1
theme.xcolor2         = xrdb.color2
theme.xcolor3         = xrdb.color3
theme.xcolor4         = xrdb.color4
theme.xcolor5         = xrdb.color5
theme.xcolor6         = xrdb.color6
theme.xcolor7         = xrdb.color7
theme.xcolor8         = xrdb.color8
theme.xcolor9         = xrdb.color9
theme.xcolor10        = xrdb.color10
theme.xcolor11        = xrdb.color11
theme.xcolor12        = xrdb.color12
theme.xcolor13        = xrdb.color13
theme.xcolor14        = xrdb.color14
theme.xcolor15        = xrdb.color15

-- General
theme.font          = "Iosevka 10"
theme.icofont       = "Segoe Fluent Icons 14"

theme.bg_normal     = theme.xbackground
theme.bg_focus      = theme.xcolor0
theme.bg_urgent     = theme.xcolor1
theme.bg_minimize   = theme.darker_bg
theme.bg_systray    = theme.xbackground

theme.fg_normal     = theme.xforeground
theme.fg_focus      = theme.xforeground
theme.fg_urgent     = theme.color0
theme.fg_minimize   = theme.color15

theme.wallpaper = theme_path .. "wall.jpg"

-- Gaps
theme.useless_gap = dpi(4)

-- Radius
theme.border_radius = dpi(4)
theme.client_radius = dpi(4)
theme.bar_radius = dpi(4)

-- Borders
theme.border_width         = dpi(0)
theme.border_normal        = theme.xcolor0
theme.border_focus         = theme.xcolor8
theme.border_marked        = theme.xcolor5

-- Pop up notifications
theme.pop_size = dpi(180)
theme.pop_bg = theme.xbackground
theme.pop_bar_bg = theme.xcolor0
theme.pop_vol_color = theme.xcolor4
theme.pop_brightness_color = theme.xcolor5
theme.pop_fg = theme.xforeground
theme.pop_border_radius = theme.border_radius

-- Taglist
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_font = theme.font
theme.taglist_bg = theme.xbackground
theme.taglist_bg_focus = theme.xcolor8
theme.taglist_fg_focus = theme.xcolor7
theme.taglist_bg_urgent = theme.xcolor1
theme.taglist_fg_urgent = theme.xbackground
theme.taglist_bg_occupied = theme.darker_bg
theme.taglist_fg_occupied = theme.xforeground
theme.taglist_bg_empty = theme.xbackground
theme.taglist_fg_empty = theme.xforeground
theme.taglist_bg_volatile = transparent
theme.taglist_fg_volatile = theme.xcolor4
theme.taglist_disable_icon = true

-- Tasklist
theme.tasklist_font = theme.font
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = theme.xcolor0
theme.tasklist_fg_focus = theme.xcolor6
theme.tasklist_bg_minimize = theme.xcolor0 .. 55
theme.tasklist_fg_minimize = theme.xforeground .. 55
theme.tasklist_bg_normal = theme.darker_bg
theme.tasklist_fg_normal = theme.xforeground
theme.tasklist_disable_task_name = false
theme.tasklist_disable_icon = true
theme.tasklist_bg_urgent = theme.xcolor0
theme.tasklist_fg_urgent = theme.xcolor1
theme.tasklist_align = "center"

-- Notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Menu
theme.menu_font = theme.font
theme.menu_submenu_icon = gears.color.recolor_image(theme_path .. "submenu.png", theme.xcolor0)
theme.menu_bg_focus = theme.darker_bg .. 70
theme.menu_fg_focus = theme.xforeground
theme.menu_bg_normal = theme.xbackground
theme.menu_fg_normal = theme.xforeground
theme.menu_height = dpi(20)
theme.menu_width = dpi(130)
theme.menu_border_color = theme.xcolor0
theme.menu_border_width = 3

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

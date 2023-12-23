local theme_assets      = require("beautiful.theme_assets")
local xresources        = require("beautiful.xresources")
local dpi               = xresources.apply_dpi
local xrdb              = xresources.get_current_theme()
local gears             = require("gears")
local gfs               = require("gears.filesystem")
local themes_path       = gfs.get_themes_dir()
local config_path       = gfs.get_configuration_dir()


-- Define Theme based on the default theme
local theme = dofile(themes_path .. "default/theme.lua")


-- Colors
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
theme.vont              = "Iosevka "
theme.font              = "Iosevka 9"
theme.font_bold         = "Iosevka Bold 9"
theme.font_boit         = "Iosevka Bold Italic 9"
theme.iconfont          = "IosevkaTerm Nerd Font 11"

theme.fg_focus          = theme.xforeground
theme.fg_normal         = theme.xforeground
theme.fg_urgent         = theme.color1

theme.bg_focus          = theme.xcolor0
theme.bg_normal         = theme.xbackground
theme.bg_urgent         = theme.xcolor1

theme.useless_gap       = dpi(4)
theme.border_radius     = dpi(0)

theme.wallpaper         = config_path .. "theme/wall.jpg"


-- Borders
theme.border_width  = dpi(4)
theme.border_focus  = theme.xcolor8
theme.border_normal = theme.xcolor0
theme.border_marked = theme.xcolor5


-- Taglist
theme.taglist_font          = theme.font_bold
theme.taglist_bg            = theme.bg_normal
theme.taglist_fg_focus      = theme.xcolor4
theme.taglist_bg_focus      = theme.bg_normal
theme.taglist_fg_occupied   = theme.xcolor8
theme.taglist_bg_occupied   = theme.background
theme.taglist_fg_empty      = theme.xcolor0
theme.taglist_bg_empty      = theme.xbackground
theme.taglist_fg_urgent     = theme.xcolor1
theme.taglist_bg_urgent     = theme.xbackground
theme.taglist_fg_volatile   = theme.xcolor3
theme.taglist_bg_volatile   = theme.xforeground

theme.taglist_squares_sel   = nil
theme.taglist_squares_unsel = nil
theme.taglist_disable_icon  = true


-- Notifications:
theme.notification_font         = theme.font
theme.notification_margin       = theme.useless_gap
theme.notification_border_color = theme.xcolor1
theme.notification_border_width = dpi(0)


-- Menu
theme.menu_font         = theme.font
theme.menu_submenu_icon = gears.color.recolor_image(config_path .. "theme/submenu.png", theme.xcolor8)
theme.menu_bg_focus     = theme.xcolor4
theme.menu_fg_focus     = theme.xbackground
theme.menu_bg_normal    = theme.xbackground
theme.menu_fg_normal    = theme.xforeground
theme.menu_height       = dpi(20)
theme.menu_width        = dpi(110)
theme.menu_border_color = theme.xcolor0
theme.menu_border_width = theme.border_width


-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

require("beautiful").init(theme)

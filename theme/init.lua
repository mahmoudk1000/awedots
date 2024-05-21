local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local gfs = require("gears.filesystem")

local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local res = gfs.get_configuration_dir() .. "/"
--
-- Define Theme based on the default theme
local theme = dofile(gfs.get_themes_dir() .. "default/theme.lua")

-- Colors
theme.xbackground = xrdb.background
theme.xforeground = xrdb.foreground
theme.xcolor0 = xrdb.color0
theme.xcolor1 = xrdb.color1
theme.xcolor2 = xrdb.color2
theme.xcolor3 = xrdb.color3
theme.xcolor4 = xrdb.color4
theme.xcolor5 = xrdb.color5
theme.xcolor6 = xrdb.color6
theme.xcolor7 = xrdb.color7
theme.xcolor8 = xrdb.color8
theme.xcolor9 = xrdb.color9
theme.xcolor10 = xrdb.color10
theme.xcolor11 = xrdb.color11
theme.xcolor12 = xrdb.color12
theme.xcolor13 = xrdb.color13
theme.xcolor14 = xrdb.color14
theme.xcolor15 = xrdb.color15

-- Fonts
theme.vont = "Iosevka "
theme.font = "Iosevka 9"
theme.font_bold = "Iosevka Bold 9"

-- Gaps
theme.useless_gap = dpi(3)

-- Wallpaper
theme.wallpaper = res .. "theme/wall.png"

-- Interface
theme.fg_focus = theme.xforeground
theme.bg_focus = theme.xcolor8
theme.fg_normal = theme.xforeground
theme.bg_normal = theme.xbackground
theme.fg_urgent = theme.color1
theme.bg_urgent = theme.xcolor0

-- Borders
theme.border_width = dpi(2)
theme.border_radius = dpi(4)
theme.border_focus = theme.bg_focus
theme.border_normal = theme.xcolor0
theme.border_marked = theme.bg_urgent

-- Taglist
theme.taglist_font = theme.font_bold
theme.taglist_fg_focus = theme.bg_normal
theme.taglist_bg_focus = theme.xcolor4
theme.taglist_fg_occupied = theme.background
theme.taglist_bg_occupied = theme.xcolor8
theme.taglist_fg_empty = theme.xbackground
theme.taglist_bg_empty = theme.xcolor0
theme.taglist_fg_urgent = theme.xbackground
theme.taglist_bg_urgent = theme.xcolor1
theme.taglist_fg_volatile = theme.xforeground
theme.taglist_bg_volatile = theme.xcolor3

theme.taglist_squares_sel = nil
theme.taglist_squares_unsel = nil
theme.taglist_disable_icon = true

-- Tsasklist
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_urgent = theme.bg_urgent
theme.tasklist_bg_minimize = theme.xcolor0

-- Notifications:
theme.notification_font = theme.font
theme.notification_spacing = dpi(theme.useless_gap * 2.2)
theme.notification_border_width = dpi(0)
theme.notification_border_color = theme.xcolor0

-- Menu
theme.menu_font = theme.font
theme.menu_submenu_icon = gears.color.recolor_image(res .. "theme/submenu.png", theme.xcolor8)
theme.menu_bg_focus = theme.xcolor4
theme.menu_fg_focus = theme.xbackground
theme.menu_bg_normal = theme.xbackground
theme.menu_fg_normal = theme.xforeground
theme.menu_height = dpi(25)
theme.menu_width = dpi(150)
theme.menu_border_color = theme.xcolor0
theme.menu_border_width = theme.border_width

-- Titlebar
theme.titlebar_fg = theme.xforeground
theme.titlebar_bg = theme.xbackground
theme.titlebar_fg_focus = theme.fg_focus
theme.titlebar_bg_focus = theme.xcolor0
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_urgent = theme.fg_urgent
theme.titlebar_bg_urgent = theme.bg_urgent

-- Bling
theme.window_switcher_widget_bg = theme.xcolor0
theme.window_switcher_widget_border_width = theme.border_width
theme.window_switcher_widget_border_radius = theme.border_radius
theme.window_switcher_widget_border_color = theme.xcolor8
theme.window_switcher_clients_spacing = dpi(10)
theme.window_switcher_client_icon_horizontal_spacing = dpi(5)
theme.window_switcher_client_width = dpi(100)
theme.window_switcher_client_height = dpi(120)
theme.window_switcher_client_margins = dpi(10)
theme.window_switcher_thumbnail_margins = dpi(5)
theme.thumbnail_scale = false
theme.window_switcher_name_margins = dpi(3)
theme.window_switcher_name_valign = "center"
theme.window_switcher_name_forced_width = theme.window_switcher_client_width
theme.window_switcher_name_font = theme.vont .. "7"
theme.window_switcher_name_normal_color = theme.xforeground
theme.window_switcher_name_focus_color = theme.xcolor4
theme.window_switcher_icon_valign = "center"
theme.window_switcher_icon_width = dpi(15)

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

require("beautiful").init(theme)

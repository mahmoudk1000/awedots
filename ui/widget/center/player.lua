local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local recolor = gears.color.recolor_image
local res_path = gears.filesystem.get_configuration_dir() .. "theme/res/"

local helpers = require("helpers")

local mpd_stuff = require("signal.mpd")

local album_cover = wibox.widget({
	image = recolor(res_path .. "cover.png", beautiful.xcolor8),
	valign = "center",
	halign = "center",
	opacity = 0.20,
	horizontal_fit_policy = "fit",
	clip_shape = helpers:rrect(),
	widget = wibox.widget.imagebox,
})

local song_name = wibox.widget({
	markup = "<b>Song</b>",
	font = beautiful.font_bold,
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local song_artist = wibox.widget({
	markup = helpers:color_markup("artist", beautiful.xcolor0),
	font = beautiful.font_bold,
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox,
})

local prev_botton = wibox.widget({
	image = recolor(res_path .. "prev.png", beautiful.xforeground),
	valign = "center",
	halign = "center",
	forced_height = dpi(10),
	forced_width = dpi(10),
	buttons = awful.button({}, awful.button.names.LEFT, function()
		awful.spawn({ "mpc", "prev" })
	end),
	widget = wibox.widget.imagebox,
})

local toggle_button = wibox.widget({
	image = recolor(res_path .. "play.png", beautiful.xcolor4),
	valign = "center",
	halign = "center",
	forced_height = dpi(10),
	forced_width = dpi(10),
	buttons = awful.button({}, awful.button.names.LEFT, function()
		awful.spawn({ "mpc", "toggle" })
	end),
	widget = wibox.widget.imagebox,
})

local next_button = wibox.widget({
	image = recolor(res_path .. "next.png", beautiful.xforeground),
	valign = "center",
	halign = "center",
	forced_height = dpi(10),
	forced_width = dpi(10),
	buttons = awful.button({}, awful.button.names.LEFT, function()
		awful.spawn({ "mpc", "next" })
	end),
	widget = wibox.widget.imagebox,
})

local player = wibox.widget({
	album_cover,
	{
		widget = wibox.widget.base.make_widget,
		bg = {
			type = "linear",
			from = { 0, 0, 0 },
			to = { 50, 150, 0 },
			stops = {
				{ 0, beautiful.xcolor4 },
				{ 1, "#00000000" },
			},
		},
		layout = wibox.container.background,
	},
	{
		{
			{
				{
					markup = helpers:color_markup("Now Playing", beautiful.xcolor0),
					font = beautiful.font,
					align = "left",
					widget = wibox.widget.textbox,
				},
				song_name,
				song_artist,
				layout = wibox.layout.fixed.vertical,
			},
			nil,
			{
				nil,
				nil,
				{
					{
						{
							prev_botton,
							toggle_button,
							next_button,
							layout = wibox.layout.flex.horizontal,
						},
						margins = dpi(5),
						layout = wibox.container.margin,
					},
					forced_height = dpi(30),
					forced_width = dpi(90),
					bg = beautiful.xcolor0,
					shape = helpers:rrect(),
					layout = wibox.container.background,
				},
				layout = wibox.layout.align.horizontal,
			},
			layout = wibox.layout.align.vertical,
		},
		margins = dpi(10),
		layout = wibox.container.margin,
	},
	layout = wibox.layout.stack,
})

awesome.connect_signal("mpd::info", function(song, artist, state)
	song_name:set_markup(song)
	song_artist:set_markup(helpers:color_markup(artist, beautiful.xcolor4))

	if state then
		toggle_button.image = recolor(res_path .. "pause.png", beautiful.xcolor4)
	else
		toggle_button.image = recolor(res_path .. "play.png", beautiful.xcolor4)
	end
end)

awesome.connect_signal("mpd::cover", function(isDefault, cover)
	if not isDefault then
		album_cover:set_image(gears.surface.load_uncached(cover))
	else
		album_cover:set_image(recolor(res_path .. "cover.png", beautiful.xcolor8))
	end
end)

return wibox.widget({
	{
		player,
		bg = beautiful.xbackground,
		border_width = dpi(1),
		border_color = beautiful.border_normal,
		shape = helpers:rrect(),
		layout = wibox.container.background,
	},
	margins = dpi(5),
	layout = wibox.container.margin,
})

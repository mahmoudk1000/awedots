local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local clock = wibox.widget({
	format = "%H.%M",
	font = beautiful.vont .. "Heavy 40",
	opacity = 0.6,
	align = "center",
	valign = "center",
	widget = wibox.widget.textclock,
})

local today = wibox.widget({
	format = "%A",
	font = beautiful.vont .. "Bold Italic 24",
	align = "center",
	valign = "center",
	widget = wibox.widget.textclock,
})

local song_name = wibox.widget({
	markup = "<b>Song</b>",
	font = beautiful.vont .. "Heavy 14",
	align = "left",
	valign = "top",
	widget = wibox.widget.textbox,
})

local song_artist = wibox.widget({
	markup = "artist",
	font = beautiful.vont .. "Bold 14",
	align = "left",
	valign = "bottom",
	widget = wibox.widget.textbox,
})

awesome.connect_signal("mpd::info", function(song, artist, _)
	song_name:set_markup(song)
	song_artist:set_markup(artist)
end)

return awful.popup({
	widget = {
		{
			clock,
			today,
			layout = wibox.layout.stack,
		},
		{
			markup = "|",
			font = beautiful.vont .. "Heavy 36",
			widget = wibox.widget.textbox,
		},
		{
			song_artist,
			song_name,
			layout = wibox.layout.flex.vertical,
		},
		layout = wibox.layout.fixed.horizontal,
	},
	visible = true,
	ontop = false,
	bg = "#00000000",
	shape = nil,
	type = "desktop",
	input_passthrough = true,
	placement = function(c)
		awful.placement.top_left(c, { margins = { left = (beautiful.useless_gap * 2) } })
	end,
})

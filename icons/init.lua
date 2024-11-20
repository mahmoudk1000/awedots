local gfs = require("gears.filesystem")
local cfg = gfs.get_configuration_dir() .. "icons/"

local icons = {}

local currentTheme = "plumpy"

icons.system = {
	avatar = "default/me.png",
	weather = {
		day = {
			clear = "weather/clear-sky_day.png",
			few_clouds = "weather/few-clouds_day.png",
			scattered_clouds = "weather/scattered-clouds_day.png",
			broken_clouds = "weather/broken-clouds_day.png",
			shower_rain = "weather/shower-rain_day.png",
			rain = "weather/rain_day.png",
			thunderstorm = "weather/thunderstorm_day.png",
			snow = "weather/snow_day.png",
			mist = "weather/mist_day.png",
		},
		night = {
			clear = "weather/clear-sky_night.png",
			few_clouds = "weather/few-clouds_night.png",
			scattered_clouds = "weather/scattered-clouds_night.png",
			broken_clouds = "weather/broken-clouds_night.png",
			shower_rain = "weather/shower-rain_night.png",
			rain = "weather/rain_night.png",
			thunderstorm = "weather/thunderstorm_night.png",
			snow = "weather/snow_night.png",
			mist = "weather/mist_night.png",
		},
	},
}

icons.themes = {
	plumpy = {
		battery = {
			char = "theme/plumpy/bat-char.png",
			full = "theme/plumpy/bat-full.png",
			nor = "theme/plumpy/bat-nor.png",
			lighting_small = "theme/plumpy/indicator.png",
			lighting_big = "theme/plumpy/indicator.png",
		},
		bluetooth = {
			pair = "theme/plumpy/blue-con.png",
			off = "theme/plumpy/blue-off.png",
			on = "theme/plumpy/blue-on.png",
		},
		apps = {
			browser = "theme/plumpy/browser.png",
			terminal = "theme/plumpy/terminal.png",
			youtube = "theme/plumpy/youtube.png",
			files = "theme/plumpy/files.png",
		},
		clock = "theme/plumpy/clock.png",
		brightness = "theme/plumpy/lamp.png",
		tone = "theme/plumpy/tone.png",
		mic = "theme/plumpy/mic.png",
		player = {
			cover = "theme/plumpy/cover.png",
			pause = "theme/plumpy/pause.png",
			play = "theme/plumpy/play.png",
			next = "theme/plumpy/next.png",
			prev = "theme/plumpy/prev.png",
		},
		tray = {
			cpu = "theme/plumpy/cpu.png",
			ram = "theme/plumpy/ram.png",
			hdd = "theme/plumpy/hdd.png",
		},
		wifi = {
			off = "theme/plumpy/no-wifi.png",
			on = "theme/plumpy/wifi.png",
		},
		volume = {
			mute = "theme/plumpy/volume_00.png",
			low = "theme/plumpy/volume_01.png",
			medium = "theme/plumpy/volume_02.png",
			high = "theme/plumpy/volume_03.png",
		},
		power = {
			reboot = "theme/plumpy/reboot.png",
			shutdown = "theme/plumpy/shutdown.png",
			suspend = "theme/plumpy/suspend.png",
			logout = "theme/plumpy/logout.png",
			lock = "theme/plumpy/lock.png",
		},
		redshift = "theme/plumpy/redshift.png",
		tags = {
			["00"] = "theme/plumpy/tag_00.png",
			["01"] = "theme/plumpy/tag_01.png",
			["02"] = "theme/plumpy/tag_02.png",
			["03"] = "theme/plumpy/tag_03.png",
			["04"] = "theme/plumpy/tag_04.png",
			["05"] = "theme/plumpy/tag_05.png",
			["06"] = "theme/plumpy/tag_06.png",
		},
		client = {
			close = "theme/plumpy/close.png",
			max = "theme/plumpy/max.png",
			unmax = "theme/plumpy/unmax.png",
			min = "theme/plumpy/min.png",
		},
		menu = {
			burger = "theme/plumpy/burger.png",
			screenshot = "theme/plumpy/scrots.png",
			submenu = "theme/plumpy/submenu.png",
		},
		unknown = "theme/plumpy/unknown.png",
	},
	pixel = {
		browser = "theme/pixel/browser.png",
		editor = "theme/pixel/editor.png",
	},
}

local function prepend_cfg_paths(icon_table)
	for k, v in pairs(icon_table) do
		if type(v) == "table" then
			prepend_cfg_paths(v)
		else
			icon_table[k] = cfg .. v
		end
	end
end

prepend_cfg_paths(icons)

setmetatable(icons, {
	__index = function(tbl, key)
		if tbl.system[key] then
			return tbl.system[key]
		elseif tbl.themes[currentTheme][key] then
			return tbl.themes[currentTheme][key]
		else
			return nil
		end
	end,
})

return icons

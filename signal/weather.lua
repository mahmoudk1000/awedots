local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local json = require("dkjson")

local helpers = require("helpers")

local M = {}

local iconMap = {
	text = {
		["01d"] = "󰖙",
		["02d"] = "󰖕",
		["03d"] = "󰖕",
		["04d"] = "󰖐",
		["09d"] = "󰖗",
		["10d"] = "󰖖",
		["11d"] = "󰙾",
		["13d"] = "󰼶",
		["50d"] = "󰖑",
		["01n"] = "󰖔",
		["02n"] = "󰼱",
		["03n"] = "󰼱",
		["04n"] = "󰼱",
		["09n"] = "󰖗",
		["10n"] = "󰖖",
		["11n"] = "󰙾",
		["13n"] = "󰼶",
		["50n"] = "󰖑",
	},
	images = {
		["01d"] = helpers:recolor("weather/clear-sky_day.png", beautiful.xcolor3),
		["02d"] = helpers:recolor("weather/few-clouds_day.png", beautiful.xcolor15),
		["03d"] = helpers:recolor("weather/scattered-clouds_day.png", beautiful.xforeground),
		["04d"] = helpers:recolor("weather/broken-clouds_day.png", beautiful.xcolor7),
		["09d"] = helpers:recolor("weather/shower-rain_day.png", beautiful.xcolor12),
		["10d"] = helpers:recolor("weather/rain_day.png", beautiful.xcolor8),
		["11d"] = helpers:recolor("weather/thunderstorm_day.png", beautiful.xcolor11),
		["13d"] = helpers:recolor("weather/snow_day.png", beautiful.xcolor15),
		["50d"] = helpers:recolor("weather/mist_day.png", beautiful.xcolor7),
		["01n"] = helpers:recolor("weather/clear-sky_night.png", beautiful.xcolor7),
		["02n"] = helpers:recolor("weather/few-clouds_night.png", beautiful.xcolor15),
		["03n"] = helpers:recolor("weather/scattered-clouds_night.png", beautiful.xforeground),
		["04n"] = helpers:recolor("weather/broken-clouds_night.png", beautiful.xcolor7),
		["09n"] = helpers:recolor("weather/shower-rain_night.png", beautiful.xcolor12),
		["10n"] = helpers:recolor("weather/rain_night.png", beautiful.xcolor8),
		["11n"] = helpers:recolor("weather/thunderstorm_night.png", beautiful.xcolor11),
		["13n"] = helpers:recolor("weather/snow_night.png", beautiful.xcolor15),
		["50n"] = helpers:recolor("weather/mist_night.png", beautiful.xcolor7),
	},
}

function M:emit_weather_info()
	local apiKey = "a89384ad87d37345cca9848d9e0b477f"
	local cityId = "361058"
	local url = "https://api.openweathermap.org/data/2.5/weather?id="
		.. cityId
		.. "&appid="
		.. apiKey
		.. "&cnt=5&units=metric&lang=en"
	local path = os.getenv("HOME") .. "/.cache/weather.json"
	local command = "curl -s '" .. url .. "' -o " .. path

	awful.spawn.easy_async(command, function(_, _, _, exitcode)
		if exitcode == 0 then
			awful.spawn.easy_async("cat " .. path, function(stdout, _, _, exitcode)
				local current = (exitcode == 0) and json.decode(stdout) or nil
				local icon, temp, desc, country, humidity

				if current then
					temp = math.ceil(current.main.temp)
					desc = helpers:uppercase_first_letter(current.weather[1].description)
					icon = iconMap.images[current.weather[1].icon]
					country = current.name .. ", " .. current.sys.country
					humidity = current.main.humidity .. "% Humidity"

					awesome.emit_signal("weather::info", temp, icon, desc, country, humidity)
				end
			end)
		end
	end)
end

gears.timer({
	timeout = 900,
	call_now = true,
	autostart = true,
	callback = function()
		M:emit_weather_info()
	end,
})

return M

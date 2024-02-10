local awful     = require("awful")
local json      = require("dkjson")
local gears     = require("gears")

local helpers = require("helpers")


local weather_stuff = {}

function weather_stuff:emit_weather_info()
    local apiKey = "a89384ad87d37345cca9848d9e0b477f"
    local cityId = "361058"
    local url = "https://api.openweathermap.org/data/2.5/weather?id=" .. cityId .. "&appid=" .. apiKey .."&cnt=5&units=metric&lang=en"
    local path = "/home/mahmoud/.cache/weather.json"
    local command = "curl -s '" .. url .. "' -o " .. path

    awful.spawn.easy_async(command, function()
        awful.spawn.easy_async("cat " .. path,
            function(stdout)
                local data = json.decode(stdout)
                local temp = 69
                local desc = "Hot"
                local land = "Reality, Sucks"

                if data then
                    temp = data.main.temp
                    desc = helpers:uppercase_first_letter(data.weather[1].description)
                    land = data.name .. ", " .. data.sys.country
                end

                awesome.emit_signal("weather::info", temp, desc, land)
            end)
    end)
end

gears.timer {
    timeout   = 1800,
    call_now  = true,
    autostart = true,
    callback = function()
        weather_stuff:emit_weather_info()
    end
}

return weather_stuff

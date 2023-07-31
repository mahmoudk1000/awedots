local awful     = require("awful")
local json      = require("dkjson")
local gears     = require("gears")


local weather_stuff = {}

function weather_stuff:emit_weather_info()
    local apiKey = "a89384ad87d37345cca9848d9e0b477f"
    local cityId = "361058"
    local url = "https://api.openweathermap.org/data/2.5/weather?id=" .. cityId .. "&appid=" .. apiKey .."&cnt=5&units=metric&lang=en"
    local command = "curl -s '" .. url .."' -o /home/mahmoud/.cache/weather.json"

    awful.spawn.easy_async_with_shell(command, function()
        awful.spawn.easy_async_with_shell("cat ~/.cache/weather.json", function(stdout, _)
            local data = json.decode(stdout)

            local temp = data.main.temp
            local desc = data.weather[1].description:gsub("^%l", string.upper)

            awesome.emit_signal("weather::info", temp, desc)
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

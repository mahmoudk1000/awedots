local json  = require("dkjson")
local gears = require("gears")

local weather_stuff = {}

function weather_stuff.update_data()
    local apiKey = "a89384ad87d37345cca9848d9e0b477f"
    local cityId = "361058"
    local url = "https://api.openweathermap.org/data/2.5/weather?id=" .. cityId .. "&appid=" .. apiKey .."&cnt=5&units=metric&lang=en"

    os.execute("curl -s '" .. url .."' -o /home/mahmoud/.cache/weather.json")
    awesome.emit_signal("weather::updated")
end

gears.timer {
    timeout   = 1800,
    call_now  = true,
    autostart = true,
    callback = weather_stuff.update_data
}

function weather_stuff.get_temp()
    local file = io.open("/home/mahmoud/.cache/weather.json", "r")
    local content = file:read("*all")
    file:close()

    local data = json.decode(content)
    return data.main.temp
end

function weather_stuff.get_desc()
    local file = io.open("/home/mahmoud/.cache/weather.json", "r")
    local content = file:read("*all")
    file:close()

    local data = json.decode(content)
    return data.weather[1].description:gsub("^%l", string.upper)
end

return weather_stuff

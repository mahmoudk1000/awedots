local awful     = require("awful")


local mpd_stuff = {}

function mpd_stuff:get_song_name()
    local command = io.popen("mpc current -f %title%")
    local name = command:read("*all")
    command:close()

    if not name or name == "" then
        return "Unknown"
    else
        return tostring(name)
    end
end

function mpd_stuff:get_song_artist()
    local command = io.popen("mpc current -f %artist%")
    local artist = command:read("*all")
    command:close()

    if not artist or artist == "" then
        return "Unknown"
    else
        return tostring(artist)
    end
end

function mpd_stuff:is_playing()
    local command = io.popen("mpc status | awk '/playing/{print \"yes\"}'")
    local state = command:read("*all")
    command:close()

    if state:match("yes") then
        return "playing"
    else
        return "paused"
    end
end


local mpd_script = [[
    sh -c 'mpc idleloop player'
]]

awful.spawn.easy_async_with_shell("ps x | grep \"mpc idleloop player\" | grep -v grep | awk '{print $1}' | xargs kill", function()
    awful.spawn.with_line_callback(mpd_script, {
        stdout = function()
            awesome.emit_signal("mpd::updated")
        end
    })
end)

return mpd_stuff

local mpd_stuff = {}

function mpd_stuff:get_song_name()
    local command = io.popen("mpc current -f %title%")
    local name = command:read("*all")
    command:close()

    if name then
        return  tostring(name)
    else
        return "Unknown"
    end
end

function mpd_stuff:get_song_artist()
    local command = io.popen("mpc current -f %artist%")
    local artist = command:read("*all")
    command:close()

    if artist then
        return tostring(artist)
    else
        return "Unknown"
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

return mpd_stuff

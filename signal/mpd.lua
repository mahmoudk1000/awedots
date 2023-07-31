local awful     = require("awful")


local mpd_stuff = {}

function mpd_stuff:emit_mpd_info()
    local command = io.popen("mpc current -f %title%")
    awful.spawn.easy_async_with_shell(
        "mpc current -f '%title%_%artist%_'; mpc status | awk '/playing/{print \"playing\"}'",
        function(stdout, _)
            local song = stdout:match("^(.-)_")
            local artist = stdout:match("_(.-)_")
            local is_playing = stdout:match("playing")

            if name == "" then
                name = "Unknown"
            end

            if artist == "" then
                artist = "Unknown"
            end

            awesome.emit_signal("mpd::info",  tostring(song), tostring(artist), tostring(is_playing))
        end)
end


local mpd_script = [[
    sh -c 'mpc idleloop player'
]]

awful.spawn.easy_async_with_shell(
    "ps x | grep \"mpc idleloop player\" | grep -v grep | awk '{print $1}' | xargs kill",
    function()
        awful.spawn.with_line_callback(mpd_script, {
            stdout = function()
                mpd_stuff.emit_mpd_info()
            end
        })
end)

return mpd_stuff

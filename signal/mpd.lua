local awful     = require("awful")
local gfs       = require("gears.filesystem")
local res_path  = gfs.get_configuration_dir() .. "theme/res/"


local mpd_stuff = {}

function mpd_stuff:emit_mpd_info()
    awful.spawn.easy_async_with_shell(
        "mpc current -f '%title%_%artist%_';mpc status | awk '/playing/{print \"playing\"}'",
        function(stdout)
            local song = stdout:match("^(.-)_")
            local artist = stdout:match("_(.-)_")
            local is_playing = stdout:match("playing")

            if song == ("" or nil) then
                song = "Unknown"
            end

            if artist == ("" or nil) then
                artist = "Unknown"
            end

            awesome.emit_signal("mpd::info",  tostring(song), tostring(artist), tostring(is_playing))
        end)
end

function mpd_stuff:progress()
    awful.spawn.easy_async_with_shell(
        "mpc | awk 'NR==2{gsub(/[%()]/,\"\",$4); print $4}'",
        function(stdout)
            awesome.emit_signal("mpd::progress", stdout)
        end)
end

function mpd_stuff:update_cover()
    local timestamp = os.time()
    awful.spawn.with_shell("rm -f " .. res_path .. "cover_*.jpg")

    awful.spawn.easy_async_with_shell(
        "ffmpeg -i $XDG_MUSIC_DIR/\"$(mpc current -f %file%)\" -map 0:1 -c:v copy -y " .. res_path .. "cover_" .. timestamp ..".jpg",
        function(_, _, _, exitcode)
            local cover
	    local isDefault

            if exitcode == 0 and gfs.file_readable(res_path .. "cover_" .. timestamp .. ".jpg") then
                isDefault = false
                cover = res_path .. "cover_" .. timestamp .. ".jpg"
            else
                isDefault = true
                cover = res_path .. "cover.png"
            end

            awesome.emit_signal("mpd::cover", isDefault, cover)
        end)
end

function mpd_stuff:start_idleloop()
    awful.spawn.easy_async_with_shell(
        "pkill -f 'mpc idleloop player'",
        function()
            awful.spawn.with_line_callback("mpc idleloop player", {
                stdout = function()
                    self:emit_mpd_info()
                    self:update_cover()
                end
            })
        end)
end

mpd_stuff:start_idleloop()
mpd_stuff:emit_mpd_info()
mpd_stuff:update_cover()
-- mpd_stuff:progress()

return mpd_stuff

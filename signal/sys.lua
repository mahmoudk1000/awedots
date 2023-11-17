local awful = require("awful")

local sys_stuff = {}

function sys_stuff:emit_sys_info()
    awful.spawn.easy_async_with_shell(
	"vmstat | awk 'NR==3 {print $15}';bash -c 'free --mega' | awk 'NR==2 {printf \"%.1f\\n\", ($2-$4)/$2*100}';df -h | awk '$NF==\"/home\" {printf \"%.1f\\n\", $5}'",
	function(stdout)
	    local vcpu = tonumber(stdout:match("([^\n]+)"))
	    local vram = tonumber(stdout:match("[^\n]+\n([^\n]+)"))
	    local vhme = tonumber(stdout:match("[^\n]+\n[^\n]+\n([^\n]+)"))

	    awesome.emit_signal("sys::info", vcpu, vram, vhme)
	end
    )
end

sys_stuff:emit_sys_info()

return sys_stuff

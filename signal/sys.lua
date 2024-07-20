local awful = require("awful")

local M = {}

function M:emit_sys_info()
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

function M:emit_uptime()
	awful.spawn.easy_async_with_shell("cat /proc/uptime", function(stdout)
		local total_seconds = tonumber(stdout:match("^(%d+%.%d+)"))

		local hours = tonumber(math.floor(total_seconds / 3600))
		local minutes = tonumber(math.floor((total_seconds % 3600) / 60))

		if hours < 1 then
			hours = tonumber(0)
		end

		awesome.emit_signal("uptime::info", hours, minutes)
	end)
end

M:emit_sys_info()
M:emit_uptime()

return M

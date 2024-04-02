local awful = require("awful")

local M = {}

function M:emit_redshift_info()
	awful.spawn.easy_async("systemctl --user is-active --quiet redshift.service", function(_, _, _, exitcode)
		local state

		if exitcode == 0 then
			state = "On"
		else
			state = "Off"
		end

		awesome.emit_signal("redshift::state", state)
	end)
end

M:emit_redshift_info()

return M

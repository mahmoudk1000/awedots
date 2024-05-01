local beautiful = require("beautiful")
local gears = require("gears")

local dpi = beautiful.xresources.apply_dpi

local M = {}

function M:color_markup(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function M:uppercase_first_letter(text)
	return text:gsub("%S+", function(word)
		return word:sub(1, 1):upper() .. word:sub(2)
	end)
end

function M:rrect(radius)
	local r = radius or beautiful.border_radius
	return function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, dpi(r))
	end
end

return M

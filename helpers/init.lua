local beautiful = require("beautiful")
local gears = require("gears")

local dpi = beautiful.xresources.apply_dpi

local helpers = {}

function helpers:color_markup(text, color)
	return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

function helpers:uppercase_first_letter(text)
	return text:gsub("%S+", function(word)
		return word:sub(1, 1):upper() .. word:sub(2)
	end)
end

function helpers:rrect(radius)
	local r = radius or beautiful.border_radius
	return function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, dpi(r))
	end
end

return helpers

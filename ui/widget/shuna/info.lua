local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local rubato = require("module.rubato")

local dpi = beautiful.xresources.apply_dpi

local helpers = require("helpers")

local function widget_template(symbol, color)
	local pie = wibox.widget({
		value = 100,
		height = dpi(120),
		width = dpi(120),
		background_color = beautiful.xcolor8,
		color = color,
		margins = dpi(10),
		shape = function(cr, w, h)
			gears.shape.arc(cr, w, h, dpi(20), 0, 2 * math.pi)
		end,
		bar_shape = function(cr, w, h)
			gears.shape.arc(cr, w, h, dpi(20), 0, math.rad(100 * 3.6), true, true)
		end,
		widget = wibox.widget.progressbar,
	})

	local percent = wibox.widget({
		markup = "100%",
		font = beautiful.vont .. "Bold 11",
		halign = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local icon = wibox.widget({
		{
			{
				image = helpers:recolor(symbol, color),
				resize = true,
				valign = true,
				halign = true,
				widget = wibox.widget.imagebox,
			},
			margins = dpi(50),
			layout = wibox.container.margin,
		},
		forced_height = dpi(120),
		forced_width = dpi(120),
		widget = wibox.container.constraint,
	})

	local widget = wibox.widget({
		{
			{
				pie,
				direction = "east",
				layout = wibox.container.rotate,
			},
			icon,
			layout = wibox.layout.stack,
		},
		bg = beautiful.xcolor0,
		shape = helpers:rrect(),
		layout = wibox.container.background,
	})

	widget:connect_signal("mouse::enter", function()
		widget.children[1]:replace_widget(icon, percent)
	end)

	widget:connect_signal("mouse::leave", function()
		widget.children[1]:replace_widget(percent, icon)
	end)

	return {
		widget = widget,
		update_value = function(new_value)
			local timed = rubato.timed({
				duration = 0.8,
				pos = math.rad(pie.value * 3.6) / math.rad(new_value * 3.6),
				subscribed = function(pos)
					pie.bar_shape = function(cr, w, h)
						gears.shape.arc(cr, w, h, dpi(20), 0, math.rad(new_value * 3.6 * pos), true, true)
					end
					percent.markup = math.floor(new_value * pos) .. "%"
				end,
			})
			timed.target = 1
			pie.value = new_value
		end,
	}
end

local cpu = widget_template("cpu.png", beautiful.xcolor5)
local ram = widget_template("ram.png", beautiful.xcolor3)
local hme = widget_template("hdd.png", beautiful.xcolor6)

awesome.connect_signal("sys::info", function(vcpu, vram, vhme)
	cpu.update_value(vcpu)
	ram.update_value(vram)
	hme.update_value(vhme)
end)

return wibox.widget({
	{
		{
			cpu,
			ram,
			hme,
			layout = wibox.layout.ratio.horizontal,
		},
		bg = beautiful.xcolor0,
		shape = helpers:rrect(),
		layout = wibox.container.background,
	},
	margins = { left = dpi(10), right = dpi(10), bottom = dpi(10) },
	layout = wibox.container.margin,
})

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local recolor = gears.color.recolor_image
local res_path = gears.filesystem.get_configuration_dir() .. "theme/icons/"

local helpers = require("helpers")

local function create_option(index, icon, command)
	return wibox.widget({
		{
			{
				id = index,
				image = recolor(icon, beautiful.xcolor4),
				resize = true,
				valign = "center",
				halign = "center",
				forced_height = dpi(35),
				forced_width = dpi(35),
				layout = wibox.widget.imagebox,
			},
			margins = dpi(15),
			layout = wibox.container.margin,
		},
		bg = beautiful.xcolor0,
		shape = helpers:rrect(),
		buttons = awful.button({}, awful.button.names.LEFT, function()
			awful.spawn.with_shell(command)
		end),
		layout = wibox.container.background,
	})
end

local lock = create_option(1, res_path .. "lock.png", "betterlockscreen -l")
local reboot = create_option(2, res_path .. "reboot.png", "reboot")
local shutdown = create_option(3, res_path .. "shutdown.png", "shutdown now")
local logout = create_option(4, res_path .. "logout.png", "pkill -KILL -u $USER")
local suspend = create_option(5, res_path .. "suspend.png", "systemctl suspend")

local power_menu = wibox.widget({
	lock,
	reboot,
	shutdown,
	logout,
	suspend,
	spacing = dpi(10),
	layout = wibox.layout.fixed.horizontal,
})

_G.bye = awful.popup({
	widget = {
		power_menu,
		margins = dpi(15),
		layout = wibox.container.margin,
	},
	ontop = true,
	visible = false,
	placement = awful.placement.centered,
	shape = helpers:rrect(),
})

local function sel_option_by_index(index)
	local options = power_menu.children

	for i, option in ipairs(options) do
		if i == index then
			option.bg = beautiful.xcolor8
		else
			option.bg = beautiful.xcolor0
		end
	end
end

local keygrabber

bye:connect_signal("property::visible", function()
	if bye.visible then
		local options = power_menu.children
		local index = 3

		sel_option_by_index(index)

		keygrabber = awful.keygrabber.run(function(_, key, event)
			if event == "press" then
				if key == "Right" then
					index = (index % #options) + 1
					sel_option_by_index(index)
				elseif key == "Left" then
					index = ((index - 2 + #options) % #options) + 1
					sel_option_by_index(index)
				elseif key == "Return" then
					bye.visible = false
					power_menu.children[index].buttons[1]:trigger()
				else
					bye.visible = false
				end
			end
		end)
	else
		if keygrabber then
			awful.keygrabber.stop(keygrabber)
		end
	end
end)

bye:connect_signal("mouse::leave", function()
	bye.visible = false
end)

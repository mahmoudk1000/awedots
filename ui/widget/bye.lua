local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local recolor   = gears.color.recolor_image

local res_path  = gears.filesystem.get_configuration_dir() .. "theme/res/"

local function create_option(index, icon, command)
    local option = wibox.widget {
        {
            {
                id              = index,
                image           = recolor(icon, beautiful.xcolor4),
                resize          = true,
                valign          = "center",
                halign          = "center",
                forced_height   = dpi(35),
                forced_width    = dpi(35),
                buttons         = awful.button({}, awful.button.names.LEFT, function()
                    awful.spawn(command)
                end),
                layout          = wibox.widget.imagebox
            },
            margins = dpi(15),
            layout  = wibox.container.margin
        },
        bg      = beautiful.xcolor0,
        shape   = function(cr, w, h)
            gears.shape.rounded_rect(cr, w, h, dpi(4))
        end,
        layout  = wibox.container.background
    }

    option:connect_signal("mouse::enter", function()
        option.bg = beautiful.xcolor8
    end)

    option:connect_signal("mouse::leave", function()
        option.bg = beautiful.xcolor0
    end)

    return option
end

local shutdown  = create_option(1, res_path .. "shutdown.png", "systemctl poweroff")
local reboot    = create_option(2, res_path .. "reboot.png", "systemctl reboot")
local lock      = create_option(3, res_path .. "lock.png", "betterlockscreen -l")
local logout    = create_option(4, res_path .. "logout.png", "killall -u $USER")
local suspend   = create_option(5, res_path .. "suspend.png", "systemctl suspend")

local power_menu = wibox.widget {
    {
        lock,
        reboot,
        shutdown,
        logout,
        suspend,
        forced_num_cols = 5,
        forced_num_rows = 1,
        homogeneous     = true,
        expand          = true,
        spacing         = dpi(10),
        layout          = wibox.layout.grid
    },
    margins = dpi(15),
    layout  = wibox.container.margin
}

Bye = awful.popup {
    widget      = power_menu,
    ontop       = true,
    visible     = false,
    placement   = awful.placement.centered,
    shape       = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, dpi(4))
    end
}

power_menu.focused_index = 3

local function move(direction)
    local current_index = power_menu.focused_index or 1
    local total_options = #power_menu.widget.children

    if direction == "right" then
        current_index = current_index % total_options + 1
        power_menu:get_children_by_id(current_index).bg = beautiful.xcolor4
    elseif direction == "left" then
        current_index = (current_index - 2 + total_options) % total_options + 1
        power_menu:get_children_by_id(current_index).bg = beautiful.xcolor4
    end

    power_menu:set_focus_by_index(current_index)
end

Bye:connect_signal("property::visible", function()
    if Bye.visible then
        awful.keygrabber.run(function(_, key, event)
            if event == "press" then
                if key == "Right" then
                    move("right")
                elseif key == "Left" then
                    move("left")
                else
                    Bye.visible = false
                end
            end
        end)
    else
        awful.keygrabber.stop()
    end
end)

Bye:connect_signal("mouse::leave", function()
    Bye.visible = false
end)

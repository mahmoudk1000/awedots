local wibox	= require("wibox")
local naughty	= require("naughty")
local ruled	= require("ruled")
local beautiful = require("beautiful")
local dpi	= beautiful.xresources.apply_dpi


-- Notification Config
naughty.config.defaults = {
    position	    = "top_right",
    title	    = "Notification",
    margin	    = beautiful.notification_margin,
    border_color    = beautiful.notification_border_color,
    border_width    = beautiful.notification_border_width
}


-- Notification Types
ruled.notification.connect_signal('request::rules', function()
    -- Critical
    ruled.notification.append_rule {
	rule       = { urgency = 'critical' },
	properties = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, timeout = 0 }
    }

    -- Normal
    ruled.notification.append_rule {
	rule       = { urgency = 'normal' },
	properties = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, timeout = 5 }
    }

    -- Low
    ruled.notification.append_rule {
	rule       = { urgency = 'low' },
	properties = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, timeout = 3 }
    }
end)

-- Notification Rules
naughty.connect_signal("request::display", function(n)
    naughty.layout.box {
	notification = n,
	type = "notification",
	bg = beautiful.xbackground,
	widget_template = {
	    {
		{
		    {
			{
			    {
				{
				    naughty.widget.title,
				    forced_height = dpi(40),
				    layout = wibox.layout.align.horizontal
				},
				left = dpi(15),
				right = dpi(15),
				widget = wibox.container.margin
			    },
			    bg = beautiful.bg_focus,
			    widget = wibox.container.background
			},
			strategy = "min",
			width = dpi(300),
			widget = wibox.container.constraint
		    },
		    strategy = "max",
		    width = dpi(400),
		    widget = wibox.container.constraint
		},
		{
		    {
			{
			    naughty.widget.message,
			    margins = dpi(15),
			    widget = wibox.container.margin
			},
			strategy = "min",
			height = dpi(60),
			widget = wibox.container.constraint
		    },
		    strategy = "max",
		    width = dpi(400),
		    widget = wibox.container.constraint
		},
		layout = wibox.layout.align.vertical
	    },
	    id = "background_role",
	    widget = naughty.container.background
	}
    }
end)

local awful = require("awful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
	-- All clients will match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			size_hints_honor = false,
			titlebars_enabled = false,
			placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			class = {
				"Nsxiv",
				"Arandr",
			},
			type = {
				"dialog",
			},
		},
		properties = {
			focus = true,
			ontop = true,
			floating = true,
			titlebars_enabled = true,
			placement = awful.placement.centered,
		},
	})

	ruled.client.append_rule({
		id = "multimedia",
		rule_any = {
			class = {
				"vlc",
				"mpv",
			},
		},
		properties = {
			tag = "3",
			switchtotag = true,
			raise = true,
			floating = true,
			draw_backdrop = false,
			placement = awful.placement.centered,
		},
	})

	ruled.client.append_rule({
		id = "zoom",
		rule_any = {
			class = {
				"zoom",
				".zoom",
			},
		},
		except_any = {
			name = {
				"Zoom - Free account",
				"Zoom Cloud Meetings",
				"zoom",
			},
		},
		properties = {
			ontop = true,
			floating = true,
			placement = awful.placement.centered,
		},
	})

	ruled.client.append_rule({
		rule = { class = "firefox" },
		properties = { screen = 1, tag = "1" },
	})
	ruled.client.append_rule({
		rule = { class = "Thunar" },
		properties = { screen = 1, tag = "4" },
	})
	ruled.client.append_rule({
		rule = { class = "obsidian" },
		properties = { screen = 1, tag = "5" },
	})
	ruled.client.append_rule({
		rule = { class = "TelegramDesktop" },
		properties = { screen = 1, tag = "5" },
	})
	ruled.client.append_rule({
		rule = { class = "Spotify" },
		properties = { screen = 1, tag = "5" },
	})
	ruled.client.append_rule({
		rule = { class = "vesktop" },
		properties = { screen = 1, tag = "5" },
	})
	ruled.client.append_rule({
		rule = { class = "thunderbird" },
		properties = { screen = 1, tag = "6" },
	})
end)

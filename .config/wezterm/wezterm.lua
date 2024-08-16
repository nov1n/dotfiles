local wezterm = require("wezterm")

local config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	color_scheme = "Tokyo Night",
	font_size = 16,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}

return config

local wezterm = require("wezterm")
local act = wezterm.action

-- Modules
local projects = require("projects")
local statusbar = require("statusbar")

-- Plugins
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- Config
local config = wezterm.config_builder()

-- System
smart_splits.apply_to_config(config, {})
config.automatically_reload_config = true
config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

-- Appearance
--config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.color_scheme = "Tokyo Night"
-- config.window_background_opacity = 0.1
-- config.macos_window_background_blur = 30
config.font_size = 16
config.window_padding = {
	left = 5,
	right = 5,
	top = 0,
	bottom = 0,
}

-- Keymap
local leader = "OPT"
config.keys = {
	{ key = "v", mods = leader, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = leader, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "c", mods = leader, action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "x", mods = leader, action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "n", mods = leader, action = act.ActivateTabRelative(-1) },
	{ key = "p", mods = leader, action = act.ActivateTabRelative(1) },
	{ key = "w", mods = leader, action = projects.choose_project() },
	{ key = "f", mods = leader, action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = leader,
		resize = leader .. "|SHIFT",
	},
})

return config

local wezterm = require("wezterm")
local act = wezterm.action

-- Modules
local projects = require("projects")
require("statusbar")
require("handlers")

-- Plugins
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- Config
local config = wezterm.config_builder()
config.disable_default_key_bindings = true

-- System
smart_splits.apply_to_config(config, {})
config.automatically_reload_config = true
config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}
-- config.unix_domains = {
-- 	{
-- 		name = "unix",
-- 	},
-- }
-- config.default_gui_startup_args = { "connect", "unix" }

-- Appearance
--config.enable_tab_bar = false
config.use_fancy_tab_bar = false
-- config.window_close_confirmation = "NeverPrompt"
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
local leader = "ALT"
config.keys = {
	-- System
	{ key = "d", mods = leader, action = wezterm.action.ShowDebugOverlay },

	-- Tabs
	{ key = "t", mods = leader, action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "1", mods = leader, action = act.ActivateTab(0) },
	{ key = "2", mods = leader, action = act.ActivateTab(1) },
	{ key = "3", mods = leader, action = act.ActivateTab(2) },
	{ key = "4", mods = leader, action = act.ActivateTab(3) },
	{ key = "5", mods = leader, action = act.ActivateTab(4) },
	{ key = "6", mods = leader, action = act.ActivateTab(5) },
	{ key = "7", mods = leader, action = act.ActivateTab(6) },
	{ key = "8", mods = leader, action = act.ActivateTab(7) },
	{ key = "9", mods = leader, action = act.ActivateTab(8) },
	{ key = "[", mods = leader, action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = leader, action = act.ActivateTabRelative(1) },

	-- Panes
	{ key = "w", mods = leader, action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "n", mods = leader, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "m", mods = leader, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "z", mods = leader, action = act.TogglePaneZoomState },

	-- Copy, paste, search
	{ key = "c", mods = leader, action = act.CopyTo("Clipboard") },
	{ key = "v", mods = leader, action = act.PasteFrom("Clipboard") },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") }, -- For raycast clipboard compatibility
	{ key = "f", mods = leader, action = act.Search({ CaseSensitiveString = "" }) },

	-- Font size
	{ key = "-", mods = leader, action = act.DecreaseFontSize },
	{ key = "=", mods = leader, action = act.IncreaseFontSize },
	{ key = "0", mods = leader, action = act.ResetFontSize },

	-- Project Switcher
	{ key = "p", mods = leader, action = projects.choose_project() },
}
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = leader,
		resize = leader .. "|SHIFT",
	},
})

return config

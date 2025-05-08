local wezterm = require("wezterm")
local act = wezterm.action

-- Modules
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

-- Performance
config.max_fps = 144
config.animation_fps = 144

-- Appearance
config.use_fancy_tab_bar = false
--config.window_close_confirmation = "NeverPrompt"
config.notification_handling = "AlwaysShow"
config.window_decorations = "RESIZE"
config.color_scheme = "Tokyo Night Moon"
config.font_size = 18
config.tab_max_width = 32
config.window_padding = {
	left = 5,
	right = 5,
	top = 0,
	bottom = 0,
}

-- Keymap
local mod = "CMD"
config.keys = {
	-- System
	{ key = "d", mods = mod, action = wezterm.action.ShowDebugOverlay },
	{ key = "q", mods = mod, action = wezterm.action.QuitApplication },

	-- Tabs
	{ key = "t", mods = mod, action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "1", mods = mod, action = act.ActivateTab(0) },
	{ key = "2", mods = mod, action = act.ActivateTab(1) },
	{ key = "3", mods = mod, action = act.ActivateTab(2) },
	{ key = "4", mods = mod, action = act.ActivateTab(3) },
	{ key = "5", mods = mod, action = act.ActivateTab(4) },
	{ key = "6", mods = mod, action = act.ActivateTab(5) },
	{ key = "7", mods = mod, action = act.ActivateTab(6) },
	{ key = "8", mods = mod, action = act.ActivateTab(7) },
	{ key = "9", mods = mod, action = act.ActivateTab(8) },
	{ key = "[", mods = mod, action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = mod, action = act.ActivateTabRelative(1) },

	-- Panes
	{ key = "w", mods = mod, action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "n", mods = mod, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "m", mods = mod, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "z", mods = mod, action = act.TogglePaneZoomState },

	-- Copy, paste, search
	{ key = "c", mods = mod, action = act.CopyTo("Clipboard") },
	{ key = "v", mods = mod, action = act.PasteFrom("Clipboard") },
	{ key = "f", mods = mod, action = act.Search({ CaseSensitiveString = "" }) },

	-- Font size
	{ key = "-", mods = mod, action = act.DecreaseFontSize },
	{ key = "=", mods = mod, action = act.IncreaseFontSize },
	{ key = "0", mods = mod, action = act.ResetFontSize },

	-- Map control backspace to Control-w
	{ key = "Backspace", mods = "CTRL", action = act.SendKey({ key = "w", mods = "CTRL" }) },
	{ key = "w", mods = "CTRL", action = act.Nop },

	-- Scrolling
	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-5) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(5) },
	{ key = "e", mods = mod, action = act.EmitEvent("trigger-vim-with-scrollback") },

	-- Toggles from a terminal pane to Neovim
	{
		key = "Backspace",
		mods = mod,
		action = wezterm.action_callback(function(_, pane)
			local is_neovim = pane:get_foreground_process_name():match("nvim$") ~= nil
			local tab = pane:tab()

			if is_neovim then
				-- If the current pane is Neovim, try to switch to the next pane in the tab
				local pane_next = tab:get_pane_direction("Down")

				if not pane_next then
					-- If there is no next pane, split the current pane vertically
					pane_next = pane:split({ direction = "Bottom", cwd = pane:get_current_working_dir().file_path })
				end

				pane_next:activate()
			else
				-- If the current pane is not Neovim, try to find a Neovim pane
				local tab_panes = tab:panes()
				print("tab_panes", tab_panes)
				local neovim_pane = nil
				for i = 1, #tab_panes do
					local tab_pane = tab_panes[i]
					local process_name = tab_pane:get_foreground_process_name()
					if process_name:match("nvim$") then
						print("process_name", process_name)
						neovim_pane = tab_pane
					end
				end

				if neovim_pane then
					-- If a Neovim pane is found, activate it and zoom the tab
					neovim_pane:activate()
					tab:set_zoomed(true)
				end
			end
		end),
	},

	-- Rerun last command in pane below
	{
		key = "r",
		mods = mod,
		action = wezterm.action_callback(function(win, pane)
			local is_neovim = pane:get_foreground_process_name():match("nvim$") ~= nil
			local tab = pane:tab()

			if is_neovim then
				-- If the current pane is Neovim, try to switch to the next pane in the tab
				local pane_next = tab:get_pane_direction("Down")

				if not pane_next then
					-- If there is no next pane, we do nothing
					print("No pane below the current one!")
					return
				end

				pane_next:activate()

				win:perform_action(wezterm.action({ SendString = "!!\n" }), pane_next)

				-- Return focus to the original pane
				win:perform_action(wezterm.action({ ActivatePaneDirection = "Up" }), pane)
			end
		end),
	},
}

smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "ALT",
		resize = "ALT|SHIFT",
	},
})

return config

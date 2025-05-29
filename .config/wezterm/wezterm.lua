local wezterm = require("wezterm")
local act = wezterm.action

--          ╭─────────────────────────────────────────────────────────╮
--          │                         Modules                         │
--          ╰─────────────────────────────────────────────────────────╯

require("handlers")

--          ╭─────────────────────────────────────────────────────────╮
--          │                         System                          │
--          ╰─────────────────────────────────────────────────────────╯

local config = wezterm.config_builder()
config.automatically_reload_config = true
config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

--          ╭─────────────────────────────────────────────────────────╮
--          │                       Performance                       │
--          ╰─────────────────────────────────────────────────────────╯

config.max_fps = 144
config.animation_fps = 144

--          ╭─────────────────────────────────────────────────────────╮
--          │                       Appearance                        │
--          ╰─────────────────────────────────────────────────────────╯

--config.window_close_confirmation = "NeverPrompt"
config.use_fancy_tab_bar = false
config.notification_handling = "AlwaysShow"
config.window_decorations = "RESIZE"
config.color_scheme = "Tokyo Night Moon"
config.font = wezterm.font("0xProto Nerd Font")
config.harfbuzz_features = { "ss01" } -- Enable cursive comments
config.font_size = 21
config.tab_max_width = 128
config.window_padding = {
	left = 0,
	right = 20,
	top = 30,
	bottom = 0,
}

--          ╭─────────────────────────────────────────────────────────╮
--          │                         Keymap                          │
--          ╰─────────────────────────────────────────────────────────╯

config.disable_default_key_bindings = true
local mod = "CMD"
config.keys = {
	-- System
	{ key = "x", mods = mod, action = act.ShowDebugOverlay },
	{ key = "q", mods = mod, action = act.QuitApplication },

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
	{ key = "{", mods = mod, action = act.MoveTabRelative(-1) },
	{ key = "}", mods = mod, action = act.MoveTabRelative(1) },
	-- Panes
	{ key = "w", mods = mod, action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "d", mods = mod, action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "D", mods = mod, action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "z", mods = mod, action = act.TogglePaneZoomState },

	-- Copy, paste, search
	{ key = "c", mods = mod, action = act.CopyTo("Clipboard") },
	{ key = "v", mods = mod, action = act.PasteFrom("Clipboard") },
	{ key = "f", mods = mod, action = act.Search("CurrentSelectionOrEmptyString") },

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
	{ key = "PageUp", action = act.ScrollByPage(-0.5) },
	{ key = "PageDown", action = act.ScrollByPage(0.5) },
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
				local neovim_pane = nil
				for i = 1, #tab_panes do
					local tab_pane = tab_panes[i]
					local process_name = tab_pane:get_foreground_process_name()
					if process_name:match("nvim$") then
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

				win:perform_action(act({ SendString = "\x03!!\n" }), pane_next)

				-- Return focus to the original pane
				win:perform_action(act({ ActivatePaneDirection = "Up" }), pane)
			end
		end),
	},
}

local cwd = {
	"cwd",
	padding = 0,
	max_length = 30,
	fmt = function(cwd)
		return tostring(cwd):gsub("carosi", "~"):match("([^/]+)/?$")
	end,
}

--          ╭─────────────────────────────────────────────────────────╮
--          │                         Plugins                         │
--          ╰─────────────────────────────────────────────────────────╯

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")

-- Tabline
tabline.setup({
	options = {
		theme = "Tokyo Night Moon",
		theme_overrides = {
			tab = {
				active = { fg = "#819EFA", bg = "#353955" },
				inactive = { fg = "#797FAD", bg = "#1C1D2A" },
				inactive_hover = { fg = "#797FAD", bg = "#353955" },
			},
		},
	},
	sections = {
		tabline_a = { "mode" },
		tabline_b = {},
		tabline_c = { " " },
		tab_active = {
			"index",
			cwd,
			{
				"process",
				icons_only = true,
			},
			{ "zoomed", padding = 0 },
		},
		tab_inactive = { "index", cwd, { "process", icons_only = true } },
		tabline_x = {},
		tabline_y = {},
		tabline_z = {},
	},
	extensions = {},
})

-- Smart splits
smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "META", -- Option key on MacOS. Karabiner maps command to option because nvim can't have cmd key mappings.
		resize = "META|SHIFT",
	},
})

return config

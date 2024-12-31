local wezterm = require("wezterm")
local mux = wezterm.mux

-- Maximize window on startup
wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Increase font size when entering Neovim's zen mode
wezterm.on("user-var-changed", function(window, pane, name, value)
	print(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- Update title with current working directory
wezterm.on("format-tab-title", function(tab)
	local pane = tab.active_pane
	local cwd = pane.current_working_dir
	if cwd then
    -- stylua: ignore
		cwd = tostring(cwd.file_path)
      :gsub("^" .. os.getenv("HOME"), "~")
      :gsub("^file://[^/]+", "")
      :match("([^/]+)/?$")
		return {
			{ Text = " " .. tab.tab_index + 1 .. ": " .. cwd .. " " },
		}
	end
end)

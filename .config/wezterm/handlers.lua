local wezterm = require("wezterm")

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

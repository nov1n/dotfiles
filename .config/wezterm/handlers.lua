local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action

-- Notify when config reloads
wezterm.on("window-config-reloaded", function(window, pane)
  window:toast_notification("Wezterm", "Configuration reloaded!", nil, 4000)
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
  if name ~= "NOTIFICATION" then
    return
  end

  local notification = wezterm.json_parse(value)

  if notification.check_focus and window:is_focused() and window:active_pane():pane_id() == pane:pane_id() then
    return
  end

  if not notification.timeout_milliseconds then
    notification.timeout_milliseconds = nil
  end

  window:toast_notification(notification.title, notification.message, nil, notification.timeout_milliseconds)
end)

-- Open scrollback in nvim
wezterm.on("trigger-vim-with-scrollback", function(window, pane)
  -- Retrieve the text from the pane
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

  -- Create a temporary file to pass to vim
  local scrollback_dir = "/tmp/scrollback/"

  -- Create scrollback directory if it doesn't exist
  os.execute("mkdir -p " .. scrollback_dir)
  local name = scrollback_dir .. string.format("%x", math.random(0, 2 ^ 32 - 1))
  local f = io.open(name, "w+")
  f:write(text)
  f:flush()
  f:close()

  -- Open a new window running vim and tell it to open the file
  window:perform_action(
    act.SpawnCommandInNewTab({
      cwd = scrollback_dir,
      args = { "nvim", "+normal G", name },
    }),
    pane
  )

  -- Wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous wrt. running
  -- this script and are not awaitable, so we just pick a number.
  --
  -- Note: We don't strictly need to remove this file, but it is nice
  -- to avoid cluttering up the temporary directory.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

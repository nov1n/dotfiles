local cmd = require("util.cmd")

local M = {}

M.LUNAR = "/usr/local/bin/lunar"

M.modes = {
  LOCATION = { name = "location", icon = "location-dot.solid" },
  MANUAL = { name = "manual", icon = "hand.solid" },
}

function M.getMode()
  local currentMode =
    cmd.run("defaults", "read fyi.lunar.Lunar adaptiveBrightnessMode"):gsub('^%s*"?(.-)%"?%s*$', "%1"):lower()
  for key, mode in pairs(M.modes) do
    if mode.name == currentMode then return M.modes[key] end
  end
  return nil
end

function M.toggleMode()
  local currentMode = M.getMode()
  if currentMode == M.modes.LOCATION then
    M.setMode(M.modes.MANUAL)
    return M.modes.MANUAL
  elseif currentMode == M.modes.MANUAL then
    M.setMode(M.modes.LOCATION)
    return M.modes.LOCATION
  else
    print("Current mode not in [manual, location], doing nothing")
    return nil
  end
end

function M.setMode(mode)
  if mode == M.modes.LOCATION or mode == M.modes.MANUAL then
    cmd.run(M.LUNAR, "mode " .. mode.name)
    return mode
  else
    error("Invalid mode: " .. tostring(mode))
  end
end

return M

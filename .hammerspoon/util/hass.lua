local cmd = require("util.cmd")

local M = {}

local log = hs.logger.new("HomeAssistant", "debug")
local hassCli = "/opt/homebrew/bin/hass-cli"

function M.command(action, entity, message)
  local args = string.format("service call %s --arguments entity_id=%s", action, entity)
  local result, error = cmd.run(hassCli, args)

  if result then
    hs.notify.new({ title = "Hammerspoon", informativeText = message }):send()
    result = result:match("^%s*(.-)%s*$") -- Trim whitespace
    log.d(result)
    return result
  else
    hs.alert.show("Error: " .. error)
    return nil
  end
end

function M.state(entity)
  local args = string.format("--no-headers --columns=state state get %s", entity)
  local result, error = cmd.run(hassCli, args)

  if result then
    result = result:match("^%s*(.-)%s*$") -- Trim whitespace
    log.d(result)
    return result
  else
    log.e("Failed to get state for " .. entity .. ": " .. error)
    return nil
  end
end

return M

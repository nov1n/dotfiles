local log = hs.logger.new("SleepWatcher", "debug")

local watcher = hs.caffeinate.watcher

local M = {}

local function executeAndLog(scriptPath)
  -- True here runs the script in a login shell
  local output, _, _, _ = hs.execute(scriptPath, true)
  log.i("\n" .. output)
end

local scriptPath = debug.getinfo(1, "S").source:sub(2)
print("scriptPath", scriptPath)
local scriptDir = scriptPath:match("(.*/)") .. "../bash/"
print("scriptDir", scriptDir)
M.sleepScript = scriptDir .. "sleep.sh"
M.wakeScript = scriptDir .. "wakeup.sh"

function M:handler(event)
  if event == watcher.systemWillSleep then
    executeAndLog(self.sleepScript)
  elseif event == watcher.systemDidWake then
    executeAndLog(self.wakeScript)
  end
end

M.watcher = watcher.new(function(event) M:handler(event) end)

function M:start() self.watcher:start() end
function M:stop() self.watcher:stop() end

return M

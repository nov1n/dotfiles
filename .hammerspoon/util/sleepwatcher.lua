local log = hs.logger.new("SleepWatcher", "debug")

local watcher = hs.caffeinate.watcher

local function executeAndLogAsync(scriptPath)
  local task = hs.task.new(scriptPath, function(exitCode, stdOut, stdErr)
    if exitCode == 0 then
      log.i("\n" .. stdOut)
    else
      log.e("Error executing script: " .. stdErr)
    end
  end)

  if not task:start() then log.e("Failed to start task for script: " .. scriptPath) end
end

local scriptPath = debug.getinfo(1, "S").source:sub(2)
local scriptDir = scriptPath:match("(.*/)") .. "../bash/"
local sleepScript = scriptDir .. "sleep.sh"
local wakeScript = scriptDir .. "wakeup.sh"

local function handler(event)
  if event == watcher.systemWillSleep then
    executeAndLogAsync(sleepScript)
  elseif event == watcher.systemDidWake then
    executeAndLogAsync(wakeScript)
  end
end

local M = {}

M.watcher = watcher.new(function(event) handler(event) end)
function M:start() self.watcher:start() end
function M:stop() self.watcher:stop() end

return M

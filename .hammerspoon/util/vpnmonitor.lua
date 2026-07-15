local vpnCheckInterval = 5

local logger = hs.logger.new("VPNMonitor", "info")

local function getVPNStatusAsync(callback)
  logger.d("Checking VPN status asynchronously...")
  local task = hs.task.new("/opt/homebrew/bin/zsh", function(exitCode, stdOut, stdErr)
    logger.d("Command output: " .. stdOut .. stdErr)
    if exitCode == 0 then
      logger.d("VPN is connected.")
      callback(true)
    else
      logger.d("VPN is not connected.")
      callback(false)
    end
  end, { "-c", "vpn status" })

  if not task then
    logger.e("Failed to create task for VPN status check.")
    callback(false)
    return
  end

  task:start()
end

local M = {}

function M:updateVPNMenubar()
  logger.d("Updating VPN menubar...")

  getVPNStatusAsync(function(isConnected)
    if isConnected then
      if not self.menubar then self.menubar = hs.menubar.new() end
      self.menubar:setIcon("/Users/carosi/dotfiles/.hammerspoon/util/shield.png")
      self.menubar:setMenu({})
      logger.d("VPN icon set to connected.")
    elseif self.menubar then
      self.menubar:delete()
      self.menubar = nil
      logger.d("VPN menubar item removed.")
    end
  end)
end

function M:start()
  logger.i("VPN monitor started with interval: " .. vpnCheckInterval .. " seconds.")
  self:updateVPNMenubar()
  self.timer = hs.timer.doEvery(vpnCheckInterval, function() self:updateVPNMenubar() end)
end

function M:stop()
  logger.i("VPN monitor stopped.")
  if self.timer then
    self.timer:stop()
    self.timer = nil
  end
end

return M

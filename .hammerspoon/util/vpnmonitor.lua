local vpnCheckInterval = 5

local logger = hs.logger.new("VPNMonitor", "info")

local function getVPNStatusAsync(callback)
  logger.i("Checking VPN status asynchronously...")
  local task = hs.task.new("/opt/homebrew/bin/zsh", function(exitCode, stdOut, stdErr)
    logger.d("Command output: " .. stdOut .. stdErr)
    if exitCode == 0 then
      logger.i("VPN is connected.")
      callback(true)
    else
      logger.i("VPN is not connected.")
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
M.menubar = hs.menubar.new()

function M:updateVPNMenubar()
  logger.i("Updating VPN menubar...")
  if not self.menubar then
    logger.e("Menubar is not initialized.")
    return
  end

  getVPNStatusAsync(function(isConnected)
    local menuItems = {}

    if isConnected then
      self.menubar:setIcon("/Users/carosi/dotfiles/.hammerspoon/util/shield.png")
      logger.i("VPN icon set to connected.")
    else
      self.menubar:setIcon(nil)
      logger.i("VPN icon set to nil.")
    end

    self.menubar:setMenu(menuItems)
  end)
end

function M:start()
  logger.i("VPN monitor started with interval: " .. vpnCheckInterval .. " seconds.")
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

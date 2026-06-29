-- Hammerspoon modules
require("hs.ipc")

-- External Spoons
hs.loadSpoon("EmmyLua")
local caff = hs.loadSpoon("Caffeine")
local habitDeck = hs.loadSpoon("HabitDeck")

-- Local modules
local sleepWatcher = require("util.sleepwatcher")
local vpnMonitor = require("util.vpnmonitor")
local appman = require("util.appman")
local winman = require("util.winman")

-- Config
local hyper = { "cmd", "ctrl", "alt" }
local meh = { "shift", "cmd", "ctrl", "alt" }
local bind = hs.hotkey.bind

-- Application Management
bind(hyper, ".", function() appman.switchToAndFromApp("com.apple.finder") end)
bind(hyper, "a", function() appman.switchToAndFromApp("com.apple.iCal") end)
bind(hyper, "[", function() hs.spotify.displayCurrentTrack() end)
bind(hyper, "=", function() hs.execute('open "devutils://auto?clipboard"') end)
bind(hyper, "f", function() appman.switchToAndFromApp("org.mozilla.firefox") end)
bind(hyper, "g", function() appman.switchToAndFromApp("com.google.Chrome") end)
bind(hyper, "m", function() appman.switchToAndFromApp("ch.protonmail.desktop") end)
bind(hyper, "y", function() appman.switchToAndFromApp("io.freetubeapp.freetube") end)
bind(hyper, "p", function() appman.switchToAndFromApp("com.spotify.client") end)
bind(hyper, "r", function() appman.switchToAndFromApp("com.apple.reminders") end)
bind(hyper, "s", function() appman.switchToAndFromApp("com.tinyspeck.slackmacgap") end)
bind(hyper, "t", function() appman.switchToAndFromApp("com.mitchellh.ghostty") end)
bind(hyper, "i", function() appman.switchToAndFromApp("com.apple.siri.launcher") end)
bind(hyper, "u", function()
  appman.switchToAndFromApp("co.podzim.boltai-mobile")
  -- HACK: Focus the composer so we can start typing immideately.
  -- Invoke BoltAI 2's "Focus Composer" menu item directly (works in empty and
  -- full chats, unlike tab navigation). We trigger the menu item rather than its
  -- cmd+/ shortcut to avoid the Homerow conflict on that combo. Activation is
  -- async, so defer until the app is actually frontmost (skip if we toggled away).
  hs.timer.doAfter(0.15, function()
    local app = hs.application.get("co.podzim.boltai-mobile")
    if app and app:isFrontmost() then
      app:selectMenuItem({ "Edit", "Focus Composer" })
    end
  end)
end)
bind(hyper, "w", function() appman.switchToAndFromApp("net.whatsapp.WhatsApp") end)

-- Window management
hs.window.animationDuration = 0
bind(hyper, "0", function() winman.centerAllWindows(1.5, 13) end)
bind(hyper, "return", winman.toggleFullScreen)
bind(hyper, "\\", winman.splitScreenTwoWindows)
bind(hyper, "-", winman.toggleMinimizeAllWindows)
-- bind(hyper, "n", showNotificationCenter) -- This is bound in "System Preferences"
bind(meh, "n", function()
  local screen = hs.screen.mainScreen()
  local frame = screen:fullFrame()
  -- Notification banners appear in the top-right corner, ~160px from right, ~80px from top
  local x = frame.x + frame.w - 160
  local y = frame.y + 90
  hs.eventtap.leftClick({ x = x, y = y })
end)

-- Console hotkeys
bind(hyper, "`", hs.reload)
bind(meh, "`", hs.openConsole)

-- Password from Keychain
hs.hotkey.bind(meh, "d", function()
  local output, status = hs.execute('security find-generic-password -s "dashlane" -w')
  if status then
    hs.eventtap.keyStrokes(output)
  else
    hs.alert.show("Failed to retrieve password from keychain")
  end
end)

-- Startup notification
hs.notify.new({ title = "Hammerspoon", informativeText = "Hammerspoon started.", withdrawAfter = 5 }):send()

-- Sleep configs
caff:start(true)
caff:setState(true)
sleepWatcher:start()

-- VPN Monitor
vpnMonitor:start()

-- HabitDeck
local credentials_file = io.open(os.getenv("HOME") .. "/.beaverhabits", "r")
if credentials_file then
  local username = credentials_file:read("*line")
  local password = credentials_file:read("*line")
  credentials_file:close()

  habitDeck:start({
    endpoint = "https://habits.carosi.nl",
    username = username,
    password = password,
    habits = { "Move", "Meditate", "Bedtime" },
    sync_interval = 10,
  })
else
  hs.alert.show("Warning: ~/.beaverhabits file not found")
end

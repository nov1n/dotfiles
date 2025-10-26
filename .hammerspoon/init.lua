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
-- TODO: / is free!!!
bind(hyper, "a", function() appman.switchToAndFromApp("com.apple.iCal") end)
bind(hyper, "[", function() hs.spotify.displayCurrentTrack() end)
bind(hyper, "=", function() hs.execute('open "devutils://auto?clipboard"') end)
bind(hyper, "f", function() appman.switchToAndFromApp("org.mozilla.firefox") end)
bind(hyper, "g", function() appman.switchToAndFromApp("com.google.Chrome") end)
bind(hyper, "m", function() appman.switchToAndFromApp("ch.protonmail.desktop") end)
bind(hyper, "p", function() appman.switchToAndFromApp("com.spotify.client") end)
bind(hyper, "r", function() appman.switchToAndFromApp("com.apple.reminders") end)
bind(hyper, "s", function() appman.switchToAndFromApp("com.tinyspeck.slackmacgap") end)
bind(hyper, "t", function() appman.switchToAndFromApp("com.github.wez.wezterm") end)
bind(hyper, "i", function() appman.switchToAndFromApp("com.apple.siri.launcher") end)
bind(hyper, "u", function()
  appman.switchToAndFromApp("co.podzim.BoltGPT")
  -- HACK: Focus the text area so we can start typing immideately.
  local frontmostApp = hs.application.frontmostApplication()
  local isBoltFrontmost = frontmostApp and frontmostApp:bundleID() == "co.podzim.BoltGPT"
  if isBoltFrontmost then
    local focusedElement = hs.uielement.focusedElement()
    local textAreaHasFocus = focusedElement and focusedElement:role() == "AXTextArea"
    if not textAreaHasFocus then hs.eventtap.keyStroke({}, "/") end
  end
end)
bind(hyper, "w", function() appman.switchToAndFromApp("net.whatsapp.WhatsApp") end)

-- Window management
hs.window.animationDuration = 0
bind(hyper, "0", function() winman.centerAllWindows(5, 15) end)
bind(hyper, "return", winman.toggleFullScreen)
bind(hyper, "\\", winman.splitScreenTwoWindows)
bind(hyper, "-", winman.toggleMinimizeAllWindows)
-- bind(hyper, "n", showNotificationCenter) -- This is bound in "System Preferences"

-- Console hotkeys
bind(hyper, "`", hs.reload)

-- Password from Keychain
hs.hotkey.bind({}, "f14", function()
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
    habits = { "Meditate" },
    sync_interval = 10,
  })
else
  hs.alert.show("Warning: ~/.beaverhabits file not found")
end

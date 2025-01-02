-- Hammerspoon modules
require("hs.ipc")

-- Local modules
local sleepWatcher = require("util.sleepwatcher")

-- External Spoons
local caff = hs.loadSpoon("Caffeine")
local habitDeck = hs.loadSpoon("HabitDeck")

-- Config
local meh = { "cmd", "ctrl", "alt" }

-- Console hotkeys
hs.hotkey.bind(meh, "`", hs.reload)

-- Startup notification
hs.notify.new({ title = "Hammerspoon", informativeText = "Hammerspoon started.", withdrawAfter = 5 }):send()

-- Sleep configs
caff:start(true)
caff:setState(true)
sleepWatcher:start()

-- HabitDeck
local credentials_file = io.open(os.getenv("HOME") .. "/.beaverhabits", "r")
if credentials_file then
  local username = credentials_file:read("*line")
  local password = credentials_file:read("*line")
  credentials_file:close()

  habitDeck:start({
    endpoint = "http://portainer.carosi.nl:7440",
    username = username,
    password = password,
    habits = { "Move", "Meditate", "Journal" },
    sync_interval = 10,
  })
else
  hs.alert.show("Warning: ~/.beaverhabits file not found")
end

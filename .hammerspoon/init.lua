require("hs.ipc")

-- External Spoons
hs.loadSpoon("Caffeine")
hs.loadSpoon("SleepWatcher")
local habitDeck = hs.loadSpoon("HabitDeck")

-- Aliases
local hyper = { "cmd", "ctrl", "alt" }
local bind = hs.hotkey.bind
local caff = spoon.Caffeine
local sleepWatcher = spoon.SleepWatcher

-- Reload Hammerspoon config
bind(hyper, "`", hs.reload)

-- Sleep configs
caff:start(true)
sleepWatcher:start()

-- HabitDeck
-- Load credentials from ~/.beaverhabits
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
    sync_interval = 60,
  })
else
  hs.alert.show("Warning: ~/.beaverhabits file not found")
end

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
local home = os.getenv("HOME")
local credentials_file = io.open(home .. "/.beaverhabits", "r")
local username, password

if credentials_file then
  username = credentials_file:read("*line")
  password = credentials_file:read("*line")
  credentials_file:close()

  habitDeck:start({
    endpoint = "http://portainer.carosi.nl:7440",
    username = username,
    password = password,
    habits = { "Move", "Meditate", "Journal" },
  })
else
  hs.alert.show("Warning: ~/.beaverhabits file not found")
  username = ""
  password = ""
end

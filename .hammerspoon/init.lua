-- External Spoons
hs.loadSpoon("MiroWindowsManager")
hs.loadSpoon("AppLauncher")
hs.loadSpoon("Caffeine")
hs.loadSpoon("SleepWatcher")

-- Aliases
local hyper = { "cmd", "ctrl", "alt", "shift" }
local bind = hs.hotkey.bind
local winman = spoon.MiroWindowsManager
local appman = spoon.AppLauncher
local caff = spoon.Caffeine
local sleepWatcher = spoon.SleepWatcher

-- Reload Hammerspoon config
bind(hyper, "`", hs.reload)

-- Sleep configs
caff:start(true)
bind({}, "f13", hs.execute("pmset sleepnow"))
sleepWatcher:start()

-- Window Management
hs.window.animationDuration = 0
winman.padding = 0.07
winman.modifiers = hyper
winman:bindHotkeys({
  up = "k",
  right = "l",
  down = "j",
  left = "h",
  nextscreen = "n",
  fullscreen = "return",
  allmax = "'",
  center = "\\",
  allcenter = "]",
  split2 = ";",
  switch = "z",
})

-- Application Management
appman.modifiers = hyper
appman:bindHotkeys({
  a = "Finder",
  c = "Calendar",
  d = function() hs.execute('open "devutils://auto?clipboard"') end,
  f = "Firefox",
  g = "Firefox Developer Edition",
  m = "Proton Mail",
  o = "Obsidian",
  p = "Spotify",
  r = "Reminders",
  s = "Slack",
  t = "Alacritty",
  u = "ChatGPT",
  w = "WhatsApp",
  y = "Freetube",
})

-- Config reload notification
hs.notify.new({ title = "Hammerspoon", informativeText = "Config reloaded" }):send()

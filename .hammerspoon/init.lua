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
sleepWatcher:start()
-- Mac immideately wakes after going to sleep when set here.
-- I set this keybinding in Raycast instead.
-- bind({}, "f13", hs.caffeinate.systemSleep)

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
  q = "Calendar",
  x = function() hs.execute('open "devutils://auto?clipboard"') end,
  f = "Firefox",
  v = "Firefox Developer Edition",
  m = "Proton Mail",
  o = "Obsidian",
  p = "Spotify",
  r = "Reminders",
  s = "Slack",
  t = "WezTerm",
  u = "Claude",
  y = "Freetube",
})

-- Config reload notification
hs.notify.new({ title = "Hammerspoon", informativeText = "Config reloaded" }):send()

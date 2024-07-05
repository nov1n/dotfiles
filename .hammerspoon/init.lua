-- External Spoons
hs.loadSpoon("MiroWindowsManager")
hs.loadSpoon("AppLauncher")
hs.loadSpoon("Caffeine")
hs.loadSpoon("HSKeybindings")

-- Aliases
local bind = hs.hotkey.bind
local hyper = { "cmd", "ctrl", "alt", "shift" }
local winman = spoon.MiroWindowsManager
local appman = spoon.AppLauncher
local caff = spoon.Caffeine
local kb = spoon.HSKeybindings

-- Global settings
hs.window.animationDuration = 0

-- Reload Hammerspoon config
bind(hyper, "`", hs.reload)

-- Enable caffeine
caff:start()
caff:setState(true)

-- Window Management
winman.padding = 0.07
winman.modifiers = hyper
winman:bindHotkeys({
  up = "k",
  right = "l",
  down = "j",
  left = "h",
  center = "\\",
  fullscreen = "return",
  nextscreen = "n",
  allcenter = "]",
  allmax = "[",
  split2 = "'",
})

-- Application Management
appman.modifiers = hyper
appman:bindHotkeys({
  a = "Finder",
  c = "Calendar",
  d = function() hs.execute('open "devutils://auto?clipboard"') end,
  f = "Firefox",
  g = "Google Chrome",
  m = "Proton Mail",
  o = "Obsidian",
  r = "Reminders",
  s = "Slack",
  t = "Alacritty",
  u = "ChatGPT",
  w = "WhatsApp",
  y = "Freetube",
})

-- Show active hotkeys
local state = true
local function toggleKeyboard()
  if state then
    kb:show()
  else
    kb:hide()
  end
  state = not state
end

hs.hotkey.bind(hyper, "x", toggleKeyboard)

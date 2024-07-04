require("amphetamine")

local am = require("app-management")

hs.loadSpoon("MiroWindowsManager")

local bind = hs.hotkey.bind
local hyper = { "cmd", "ctrl", "alt", "shift" }

bind(hyper, "`", hs.reload)

-- Window Management
hs.window.animationDuration = 0
spoon.MiroWindowsManager.padding = 0.07
spoon.MiroWindowsManager:bindHotkeys({
  up = { hyper, "up" },
  right = { hyper, "right" },
  down = { hyper, "down" },
  left = { hyper, "left" },
  fullscreen = { hyper, "return" },
  nextscreen = { hyper, "n" },
})

-- Application Management
bind(hyper, "p", function() am.switchToAndFromApp("Spotify") end)
bind(hyper, "[", function() hs.spotify.displayCurrentTrack() end)
bind(hyper, "c", function() am.switchToAndFromApp("com.jetbrains.intellij") end)
bind(hyper, "/", function() am.switchToAndFromApp("com.apple.iCal") end)
bind(hyper, ".", function() am.switchToAndFromApp("com.apple.finder") end)
bind(hyper, "d", function() hs.execute('open "devutils://auto?clipboard"') end)

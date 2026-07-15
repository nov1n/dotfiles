local M = {}

local menubar = nil
local muted = false
local STATE_FILE = os.getenv("HOME") .. "/.hammerspoon/mic_muted"

local function readState()
  local f = io.open(STATE_FILE, "r")
  if f then
    f:close()
    return true
  end
  return false
end

local function writeState(isMuted)
  if isMuted then
    local f = io.open(STATE_FILE, "w")
    if f then f:close() end
  else
    os.remove(STATE_FILE)
  end
end

local micMuteIcon = nil

local function updateMenuBar()
  if muted then
    if not menubar then menubar = hs.menubar.new() end
    if menubar then menubar:setIcon(micMuteIcon) end
  elseif menubar then
    menubar:delete()
    menubar = nil
  end
end

function M.toggle()
  muted = not muted
  writeState(muted)
  updateMenuBar()
end

function M.start()
  micMuteIcon = hs.image.imageFromPath(os.getenv("HOME") .. "/dotfiles/.hammerspoon/util/mute.png")
  if micMuteIcon then micMuteIcon:size({ w = 18, h = 18 }, true) end
  muted = readState()
  updateMenuBar()
  hs.hotkey.bind({}, "pageup", M.toggle)
end

return M

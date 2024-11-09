local audio = require("hs.audiodevice")
local timer = require("hs.timer")

local M = {}

-- Input and Output device abstractions
local Input = {}
Input.__index = Input

function Input.new(name) return setmetatable({ name = name }, Input) end

function Input:setDefault()
  local device = audio.findInputByName(self.name)
  if device then device:setDefaultInputDevice() end
end

local Output = {}
Output.__index = Output

function Output.new(name) return setmetatable({ name = name }, Output) end

function Output:setDefault()
  local device = audio.findOutputByName(self.name)
  if device then device:setDefaultOutputDevice() end
end

-- Profile abstraction
local Profile = {}
Profile.__index = Profile

function Profile.new(name, input, output, icon)
  return setmetatable({ name = name, input = input, output = output, icon = icon }, Profile)
end

-- Local device definitions
local CORSAIR = Input.new("CORSAIR HS80 RGB Wireless Gaming Receiver")
local WEBCAM = Input.new("C922 Pro Stream Webcam")
local DAC = Output.new("Audient iD44")
local CORSAIR_OUTPUT = Output.new("CORSAIR HS80 RGB Wireless Gaming Receiver")

-- Profile definitions
M.HEADSET_PROFILE = Profile.new("Headset", CORSAIR, CORSAIR_OUTPUT, "headphones.solid")
M.SPEAKER_PROFILE = Profile.new("Speakers", WEBCAM, DAC, "volume-high.solid")

M.profiles = { M.HEADSET_PROFILE, M.SPEAKER_PROFILE }

local function mute(shouldMute)
  for _, device in ipairs(audio.allOutputDevices()) do
    device:setMuted(shouldMute)
  end
end

function M.switchProfile(profile)
  mute(true)
  timer.usleep(3 * 1000000)
  profile.input:setDefault()
  profile.output:setDefault()
  timer.usleep(3 * 1000000)
  mute(false)
  return profile
end

function M.toggleProfile()
  local current = audio.defaultOutputDevice()
  if current:name() == CORSAIR_OUTPUT.name then
    return M.switchProfile(M.SPEAKER_PROFILE)
  else
    return M.switchProfile(M.HEADSET_PROFILE)
  end
end

function M.getCurrentProfile()
  local currentOutput = audio.defaultOutputDevice():name()
  for _, profile in ipairs(M.profiles) do
    if profile.output.name == currentOutput then return profile end
  end
  return nil
end

return M

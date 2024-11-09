local audioProfiles = require("util.audio_profiles")
local images = require("streamdeck.images")
local hass = require("util.hass")
local cmd = require("util.cmd")
local event = hs.eventtap.event

local audioProfileButton = {
  imageProvider = function() return images.materialIcon(audioProfiles.getCurrentProfile().icon) end,
  updateInterval = 10,
  onClick = function(deck, index)
    local profile = audioProfiles.toggleProfile()
    local image = images.fromText(profile.icon)
    deck:setButtonImage(index, image)
  end,
}

local sleepButton = {
  imageProvider = function() return images.materialIcon("bed.solid") end,
  onClick = function() hs.caffeinate.systemSleep() end,
}

local prevButton = {
  imageProvider = function() return images.materialIcon("backward.solid") end,
  onClick = function() event.newSystemKeyEvent("PREV", true):post() end,
}

local pausePlayButton = {
  imageProvider = function() return images.materialIcon("pause.solid") end,
  onClick = function() event.newSystemKeyEvent("PLAY", true):post() end,
}

local nextButton = {
  imageProvider = function() return images.materialIcon("forward.solid") end,
  onClick = function() event.newSystemKeyEvent("NEXT", true):post() end,
}

local doorButton = {
  imageProvider = function() return images.materialIcon("door-open.solid") end,
  onClick = function() hass.command("automation.open_doors", "", "Doors opened") end,
}

local sitButton = {
  imageProvider = function() return images.materialIcon("chair.solid") end,
  onClick = function() hass.command("button.press", "button.standing_desk_preset_3", "Desk set to sitting.") end,
}

local standButton = {
  imageProvider = function() return images.materialIcon("person.solid") end,
  onClick = function() hass.command("button.press", "button.standing_desk_preset_2", "Desk set to standing.") end,
}

local locationModeButton = {
  imageProvider = function() return images.materialIcon("location-dot.solid") end,
  onClick = function() cmd.run(cmd.LUNAR, "mode location") end,
}

local manualModeButton = {
  imageProvider = function() return images.materialIcon("hand.solid") end,
  onClick = function() cmd.run(cmd.LUNAR, "mode manual") end,
}

local outsideButton = {
  imageProvider = function() return images.materialIcon("sun.solid") end,
  onClick = function() end,
}

local meditateButton = {
  imageProvider = function() return images.materialIcon("hands-praying.solid") end,
  onClick = function() end,
}

local stretchButton = {
  imageProvider = function() return images.materialIcon("mixer.brands") end,
  onClick = function() end,
}

local journalButton = {
  imageProvider = function() return images.materialIcon("pen-to-square.solid") end,
  onClick = function() end,
}

local bedtimeButton = {
  imageProvider = function() return images.materialIcon("clock.regular") end,
  onClick = function() end,
}

local dummyButton = {
  imageProvider = function() return images.materialIcon("hand.solid") end,
  onClick = function() end,
}

-- stylua: ignore start
return {
  sleepButton,    audioProfileButton,  prevButton,    pausePlayButton,     nextButton,
  sitButton,      standButton,         doorButton,    locationModeButton,  manualModeButton,
  outsideButton,  meditateButton,      journalButton, stretchButton,       bedtimeButton,
}
-- stylua: ignore end

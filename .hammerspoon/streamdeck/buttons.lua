local images = require("streamdeck.images")

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
  imageProvider = function() return images.none() end,
  onClick = function() end,
}

-- stylua: ignore start
return {
  dummyButton,    dummyButton,         dummyButton,     dummyButton,         dummyButton,
  dummyButton,    dummyButton,         dummyButton,     dummyButton,         dummyButton,
  outsideButton,  meditateButton,      journalButton,   stretchButton,       bedtimeButton,
}
-- stylua: ignore end

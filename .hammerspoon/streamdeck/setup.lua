local M = {}

local log = hs.logger.new("StreamDeckFramework", "info")

M.buttons = {}
M.streamdeck = nil

local function updateButtonImage(button, index)
  local image = button.imageProvider()
  M.streamdeck:setButtonImage(index, image)
end

local function setupButton(button, index)
  updateButtonImage(button, index)
  if button.updateInterval then
    button.updateTimer = hs.timer.new(button.updateInterval, function() updateButtonImage(button, index) end)
    button.updateTimer:start()
  end
end

local function teardownButton(button)
  if button.updateTimer then
    button.updateTimer:stop()
    button.updateTimer = nil
  end
end

local function handleStreamDeck(connected, deck)
  if connected then
    log.i("Stream Deck connected")
    M.streamdeck = deck
    for index, button in pairs(M.buttons) do
      setupButton(button, index)
    end
    M.streamdeck:buttonCallback(function(deckIn, index, state)
      if not state then return end -- Release events are not supported yet
      print("Clicked button " .. index)
      M.buttons[index].onClick(deckIn, index, state)
    end)
  else
    log.i("Stream Deck disconnected")
    for _, button in pairs(M.buttons) do
      teardownButton(button)
    end
    M.streamdeck = nil
  end
end

function M.start(buttons)
  M.buttons = buttons
  hs.streamdeck.init(handleStreamDeck)
end

return M

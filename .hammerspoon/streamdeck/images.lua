local M = {}

M.buttonWidth = 72
M.buttonHeight = 72

local systemBackgroundColor = hs.drawing.color.lists()["System"]["windowBackgroundColor"]
local tintColor = hs.drawing.color.lists()["System"]["systemOrangeColor"]

-- Shared cached canvas
local sharedCanvas = hs.canvas.new({ w = M.buttonWidth, h = M.buttonHeight })

local function imageWithCanvasContents(contents)
  sharedCanvas:replaceElements(contents)
  return sharedCanvas:imageFromCanvas()
end

function M.fromText(text, options)
  options = options or {}
  local textColor = options["textColor"] or tintColor
  local backgroundColor = options["backgroundColor"] or systemBackgroundColor
  local font = options["font"] or ".AppleSystemUIFont"
  local fontSize = options["fontSize"] or 50
  local elements = {}
  table.insert(elements, {
    action = "fill",
    frame = { x = 0, y = 0, w = M.buttonWidth, h = M.buttonHeight },
    fillColor = backgroundColor,
    type = "rectangle",
  })
  table.insert(elements, {
    frame = { x = 0, y = 0, w = M.buttonWidth, h = M.buttonHeight },
    text = hs.styledtext.new(text, {
      font = { name = font, size = fontSize },
      paragraphStyle = { alignment = "center" },
      color = textColor,
    }),
    type = "text",
  })
  return imageWithCanvasContents(elements)
end

function M.materialIcon(name)
  local scriptPath = debug.getinfo(1).source:match("@?(.*/)")
  local iconPath = scriptPath .. "../Stream-Deck-Font-Awesome/streamdeck-fontawesome-256/" .. name .. ".png"
  print(iconPath)

  local image = hs.image.imageFromPath(iconPath)
  if image then
    return image
  else
    return M.fromText("❔")
  end
end

return M

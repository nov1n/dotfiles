
local GRID_SIZE = 4
local HALF_GRID_SIZE = GRID_SIZE / 2

-- Set the grid size and add a few pixels of margin
-- Also, don't animate window changes... That's too slow
hs.grid.setGrid(GRID_SIZE .. "x" .. GRID_SIZE)
-- hs.grid.setMargins({ 5, 5 })
hs.window.animationDuration = 0

-- Defining screen positions
local screenPositions = {}
screenPositions.left = { x = 0, y = 0, w = HALF_GRID_SIZE, h = GRID_SIZE }
screenPositions.right = { x = HALF_GRID_SIZE, y = 0, w = HALF_GRID_SIZE, h = GRID_SIZE }
screenPositions.top = { x = 0, y = 0, w = GRID_SIZE, h = HALF_GRID_SIZE }
screenPositions.bottom = { x = 0, y = HALF_GRID_SIZE, w = GRID_SIZE, h = HALF_GRID_SIZE }

screenPositions.topLeft = { x = 0, y = 0, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE }
screenPositions.topRight = { x = HALF_GRID_SIZE, y = 0, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE }
screenPositions.bottomLeft = { x = 0, y = HALF_GRID_SIZE, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE }
screenPositions.bottomRight = { x = HALF_GRID_SIZE, y = HALF_GRID_SIZE, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE }

M.screenPositions = screenPositions

-- This function will move either the specified or the focuesd
-- window to the requested screen position
function M.moveWindowToPosition(cell, window)
  if window == nil then window = hs.window.focusedWindow() end
  if window then
    local screen = window:screen()
    hs.grid.set(window, cell, screen)
  end
end

-- This function will move either the specified or the focused
-- window to the center of the sreen and let it fill up the
-- entire screen.
function M.windowMaximize(factor, window)
  if window == nil then window = hs.window.focusedWindow() end
  if window then window:maximize() end
end

function M.centerWithPadding(padding)
  local paddingPercentage = padding -- 10% of the screen dimensions

  -- Get the screen dimensions
  local screen = hs.screen.mainScreen()
  local screenFrame = screen:frame()
  local screenWidth = screenFrame.w
  local screenHeight = screenFrame.h
  -- Calculate the padding based on the screen dimensions
  local paddingX = screenWidth * paddingPercentage
  local paddingY = screenHeight * paddingPercentage

  -- Get the focused window
  local win = hs.window.focusedWindow()
  if not win then return end

  -- Calculate the new size and position
  local newWidth = screenWidth - (2 * paddingX)
  local newHeight = screenHeight - (2 * paddingY)
  local newLeft = paddingX
  local newTop = paddingY

  -- Move and resize the window
  win:setFrame(hs.geometry.rect(newLeft, newTop, newWidth, newHeight))
end

return M

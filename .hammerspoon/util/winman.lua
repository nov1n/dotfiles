-- Window Management utilities
local M = {}

-- Function to resize and center all windows with configurable padding (fast, no delays)
function M.centerAllWindows(verticalPaddingPercent, horizontalPaddingPercent)
  -- Check if external monitor is connected
  local screens = hs.screen.allScreens()
  local hasExternalMonitor = false

  -- Look for external monitors by checking screen names
  for _, screen in ipairs(screens) do
    local name = screen:name()
    -- Check if it's NOT a built-in screen (starts with "Built-in")
    local isBuiltIn = name:find("^Built%-in") ~= nil
    if not isBuiltIn then
      hasExternalMonitor = true
      break
    end
  end

  -- If no external monitor, maximize to 100% (no padding)
  if not hasExternalMonitor then
    verticalPaddingPercent = 0
    horizontalPaddingPercent = 0
  else
    verticalPaddingPercent = verticalPaddingPercent or 5  -- Default 5% vertical padding
    horizontalPaddingPercent = horizontalPaddingPercent or 15  -- Default 15% horizontal padding
  end

  -- Get all visible windows and resize them immediately
  local windows = hs.window.visibleWindows()
  local count = 0

  for _, win in ipairs(windows) do
    if win and not win:isMinimized() and win:isStandard() then
      local winScreen = win:screen()
      if winScreen then
        local winScreenFrame = winScreen:frame()
        
        -- Calculate percentage-based padding
        local verticalPadding = math.floor(winScreenFrame.h * verticalPaddingPercent / 100)
        local horizontalPadding = math.floor(winScreenFrame.w * horizontalPaddingPercent / 100)
        
        local winTargetWidth = winScreenFrame.w - (horizontalPadding * 2)
        local winTargetHeight = winScreenFrame.h - (verticalPadding * 2)

        -- Calculate position with padding
        local x = winScreenFrame.x + horizontalPadding
        local y = winScreenFrame.y + verticalPadding

        -- Set the window frame immediately using geometry.rect like the old implementation
        win:setFrame(hs.geometry.rect(x, y, winTargetWidth, winTargetHeight))
        count = count + 1
      end
    end
  end

  local paddingMsg = hasExternalMonitor and
    string.format("with %.1f%% vertical, %.1f%% horizontal padding", verticalPaddingPercent, horizontalPaddingPercent) or
    "maximized to 100% (no external monitor)"

  hs.alert.show(string.format("Resized %d windows %s", count, paddingMsg))
end

-- Function to toggle fullscreen for the focused window
function M.toggleFullScreen()
  local win = hs.window.focusedWindow()
  if win then
    win:toggleFullScreen()
  end
end

-- Function to put two last focused windows side by side in split screen
function M.splitScreenTwoWindows()
  local windows = hs.window.orderedWindows()

  if #windows < 2 then
    hs.alert.show("Need at least 2 windows for split screen")
    return
  end

  local win1 = windows[1]  -- Most recently focused
  local win2 = windows[2]  -- Second most recently focused

  -- Filter for valid, standard windows
  local validWindows = {}
  for _, win in ipairs(windows) do
    if win and win:isStandard() and not win:isMinimized() then
      table.insert(validWindows, win)
    end
  end

  if #validWindows < 2 then
    hs.alert.show("Need at least 2 valid windows for split screen")
    return
  end

  win1 = validWindows[1]
  win2 = validWindows[2]

  -- Use the screen of the first window
  local screen = win1:screen()
  local screenFrame = screen:frame()
  local halfWidth = math.floor(screenFrame.w / 2)

  -- Exit fullscreen if needed
  if win1:isFullScreen() then
    win1:toggleFullScreen()
  end

  if win2:isFullScreen() then
    win2:toggleFullScreen()
  end

  -- Set window frames
  win1:setFrame({
    x = screenFrame.x,
    y = screenFrame.y,
    w = halfWidth,
    h = screenFrame.h
  })

  win2:setFrame({
    x = screenFrame.x + halfWidth,
    y = screenFrame.y,
    w = halfWidth,
    h = screenFrame.h
  })

  -- Focus the first window
  win1:focus()
end

-- Function to toggle minimizing/maximizing all windows
function M.toggleMinimizeAllWindows()
  -- Get all windows including visible ones
  local allWindows = hs.window.allWindows()
  local visibleWindows = hs.window.visibleWindows()

  -- More aggressive filtering - include more window types
  local function isValidWindow(win)
    if not win then return false end
    -- Skip menu bars, dock, and desktop
    local role = win:role()
    local subrole = win:subrole()
    if role == "AXMenuBar" or role == "AXSystemDialog" or subrole == "AXSystemDialog" then
      return false
    end
    -- Include standard windows and some others
    return win:isStandard() or (win:title() and win:title() ~= "" and win:application())
  end

  -- Count truly visible windows (not minimized)
  local visibleCount = 0
  for _, win in ipairs(visibleWindows) do
    if isValidWindow(win) and not win:isMinimized() then
      visibleCount = visibleCount + 1
    end
  end

  if visibleCount > 0 then
    -- Minimize all visible windows
    local count = 0
    for _, win in ipairs(visibleWindows) do
      if isValidWindow(win) and not win:isMinimized() then
        local success, err = pcall(function()
          win:minimize()
        end)
        if success then
          count = count + 1
        end
      end
    end
    hs.alert.show(string.format("Minimized %d windows", count))
  else
    -- Restore all minimized windows
    local count = 0
    for _, win in ipairs(allWindows) do
      if isValidWindow(win) and win:isMinimized() then
        local success, err = pcall(function()
          win:unminimize()
        end)
        if success then
          count = count + 1
        end
      end
    end
    hs.alert.show(string.format("Restored %d windows", count))
  end
end

return M

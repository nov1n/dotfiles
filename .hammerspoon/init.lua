hs.hotkey.bind({ "cmd" }, "D", function()
	hs.execute('open "devutils://auto?clipboard"')
end)

hs.hotkey.bind({ "cmd" }, "P", function()
	hs.application.launchOrFocus("Spotify")
	hs.eventtap.keyStroke({ "cmd" }, "k")
end)

hs.hotkey.bind({ "ctrl", "alt" }, "M", function()
	-- Define the padding percentage
	local paddingPercentage = 0.1 -- 10% of the screen dimensions

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
	if not win then
		return
	end

	-- Calculate the new size and position
	local newWidth = screenWidth - (2 * paddingX)
	local newHeight = screenHeight - (2 * paddingY)
	local newLeft = paddingX
	local newTop = paddingY

	-- Move and resize the window
	win:setFrame(hs.geometry.rect(newLeft, newTop, newWidth, newHeight))
end)

-- AppManagement originally by jqno
local M = {}

-- Quickly move to and from a specific app
-- (Thanks Teije)
local previousApp = ""

function M.switchToAndFromApp(bundleID)
	local focusedWindow = hs.window.focusedWindow()

	if focusedWindow == nil then
		hs.application.launchOrFocusByBundleID(bundleID)
	elseif focusedWindow:application():bundleID() == bundleID then
		if previousApp == nil then
			hs.window.switcher.nextWindow()
		else
			previousApp:activate()
		end
	else
		previousApp = focusedWindow:application()
		hs.application.launchOrFocusByBundleID(bundleID)
	end
end

return M

tell application "System Events"
	set frontApp to name of first application process whose frontmost is true
end tell

if frontApp is "Google Chrome" then
	tell application "Google Chrome"
		set currentURL to URL of active tab of front window
	end tell
else if frontApp is "Safari" then
	tell application "Safari"
		set currentURL to URL of front document
	end tell
else if frontApp is "Firefox" then
	tell application "Firefox" to activate
	tell application "System Events"
		keystroke "l" using {command down}
		keystroke "c" using {command down}
	end tell
	delay 0.5
	set currentURL to the clipboard
else
	set currentURL to ""
end if

return currentURL

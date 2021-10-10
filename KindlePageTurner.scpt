set LEFT_BINDING to 124
set RIGHT_BINDING to 123

set pages to 5
set savePath to "~/Documents/*****/"
set pageTurningDirection to LEFT_BINDING
set captureSize to "1250x1850+1800+170"

set capturedScreenPath to savePath & "_capturedScreen.png"
set translatedTextPath to savePath & "_translatedText"
set imageDir to savePath & "image/"
set textDir to savePath & "text/"

repeat with p from 1 to pages
	set serialNum to text -3 thru -1 of ("000" & p)
	set fileName to "p" & serialNum
	set bookImagePath to imageDir & fileName & ".png"
	set bookTextPath to textDir & fileName & ".txt"
	
	activate application "Kindle"
	
	do shell script "screencapture " & capturedScreenPath
	do shell script "/usr/local/bin/convert " & capturedScreenPath & " -crop " & captureSize & " " & bookImagePath
	do shell script "/usr/local/bin/tesseract  " & bookImagePath & " " & translatedTextPath & " -l jpn_f"
	do shell script "cat " & translatedTextPath & ".txt | sed -e ':loop' -e 'N; $!b loop' -e 's/\\n//g' | sed 's/。/。\\n/g' > " & bookTextPath
	
	if not p = pages then
		tell application "Kindle"
			activate
			tell application "System Events"
				key code pageTurningDirection
			end tell
			delay 2
		end tell
	end if
end repeat

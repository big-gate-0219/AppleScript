set LEFT_BINDING to 124
set RIGHT_BINDING to 123

set pages to 500
set savepath to "~/Documents/*****/"
set pageTurningDirection to LEFT_BINDING

repeat with p from 1 to pages
	set serialNum to text -3 thru -1 of ("000" & p)
	set saveOriginalFile to (savepath & "original/p" & serialNum & ".png")
	set saveTrimmingFile to (savepath & "trimming/p" & serialNum & ".png")
	set saveTextFile to (savepath & "text/p" & serialNum)
	
	tell application "Kindle"
		activate
		do shell script "screencapture " & saveOriginalFile
		tell application "System Events"
			key code pageTurningDirection
		end tell
	end tell
	
	do shell script "/usr/local/bin/convert " & saveOriginalFile & " -crop 1250x1900+1800+170 " & saveTrimmingFile
	do shell script "/usr/local/bin/tesseract  " & saveTrimmingFile & " " & saveTextFile & " -l jpn_f"
	
	
	do shell script "cat " & saveTextFile & ".txt | sed -e ':loop' -e 'N; $!b loop' -e 's/\\n//g' | sed 's/。/。\\n/g' > " & saveTextFile & ".md"
end repeat

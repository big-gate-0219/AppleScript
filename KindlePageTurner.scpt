-- å®æ°å®ç¾©
set LEFT_BINDING to 124
set RIGHT_BINDING to 123

-- æåå®ç¾©å¤æ°
set pages to 5
set savePath to "~/Documents/*****/"
set pageTurningDirection to LEFT_BINDING
set captureSize to "1250x1850+1800+170"

-- ä½æ¥­å¤æ°
set capturedScreenPath to savePath & "_capturedScreen.png"
set translatedTextPath to savePath & "_translatedText"
set imageDir to savePath & "image/"
set textDir to savePath & "text/"

repeat with p from 1 to pages
	set serialNum to text -3 thru -1 of ("000" & p)
	set fileName to "p" & serialNum
	set bookImagePath to imageDir & fileName & ".png"
	set bookTextPath to textDir & fileName & ".txt"
	
	-- Kindleãã¢ã¯ãã£ãã«ããï¼èµ·åããã¦ããªããã°èµ·åããï¼
	activate application "Kindle"
	
	-- ç»é¢ã­ã£ããã£ãåå¾ãKindleã®æ¸ç±é¨åã®ã¿ãæ½åºãã
	do shell script "screencapture " & capturedScreenPath
	do shell script "/usr/local/bin/convert " & capturedScreenPath & " -crop " & captureSize & " " & bookImagePath
	
	-- æ¸ç±ç»åã®æå­èªè­ãè¡ããã­ã¹ããã¼ã¿åããã
	do shell script "/usr/local/bin/tesseract  " & bookImagePath & " " & translatedTextPath & " -l jpn_f"
	
	-- ãã­ã¹ããã¼ã¿ãæ­£è¦åå¦çããï¼æ¹è¡ãåãé¤ããã®ã¡ãå¥èª­ç¹ã®å¾ãã«æ¹è¡ãä»ä¸ããï¼ã
	do shell script "cat " & translatedTextPath & ".txt | sed -e ':loop' -e 'N; $!b loop' -e 's/\\n//g' | sed 's/ã/ã\\n/g' > " & bookTextPath
	
	-- ãã­ã¹ããã¼ã¿ãèª­ã¿ä¸ãã
	do shell script "cat " & bookTextPath & " | say"
	
	-- ãã¼ã¸æ²ããè¡ã
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

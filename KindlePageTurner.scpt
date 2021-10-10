-- 定数定義
set LEFT_BINDING to 124
set RIGHT_BINDING to 123

-- 挙動定義変数
set pages to 5
set savePath to "~/Documents/IoTの教科書/"
set pageTurningDirection to LEFT_BINDING
set captureSize to "1250x1850+1800+170"

-- 作業変数
set capturedScreenPath to savePath & "_capturedScreen.png"
set translatedTextPath to savePath & "_translatedText"
set imageDir to savePath & "image/"
set textDir to savePath & "text/"

repeat with p from 1 to pages
	set serialNum to text -3 thru -1 of ("000" & p)
	set fileName to "p" & serialNum
	set bookImagePath to imageDir & fileName & ".png"
	set bookTextPath to textDir & fileName & ".txt"
	
	-- Kindleをアクティブにする（起動されていなければ起動する）
	activate application "Kindle"
	
	-- 画面キャプチャを取得しKindleの書籍部分のみを抽出する
	do shell script "screencapture " & capturedScreenPath
	do shell script "/usr/local/bin/convert " & capturedScreenPath & " -crop " & captureSize & " " & bookImagePath
	
	-- 書籍画像の文字認識を行いテキストデータ化する。
	do shell script "/usr/local/bin/tesseract  " & bookImagePath & " " & translatedTextPath & " -l jpn_f"
	
	-- テキストデータを正規化処理する（改行を取り除いたのち、句読点の後ろに改行を付与する）。
	do shell script "cat " & translatedTextPath & ".txt | sed -e ':loop' -e 'N; $!b loop' -e 's/\\n//g' | sed 's/。/。\\n/g' > " & bookTextPath
	
	-- テキストデータを読み上げる
	do shell script "cat " & bookTextPath & " | say"
	
	-- ページ捲りを行う
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

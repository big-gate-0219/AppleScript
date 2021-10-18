---
marp: true
theme: gaia
paginate: true
header: 'Get Mac to read my Kindle aloud'
---

# MacにKindleを音読してもらおう

---

## 前提

- 個人的な利用を前提として作成。
- Mac上で動作することを想定。
- 一部、Windows上での動作を想定した箇所がある。

---

## Agenda

1. モチベーション
2. 最初の実験
3. 読み聞かせてもらいたい
   1. 文字認識
   2. 読み上げ
   3. 次ページへ移動
4. もっと自然なイントネーションで

---

## モチベーション

- **背景**
  - 専門書を一度読んでも頭に入らなくなってきている
  - 集中して読めるページ数が減ってきている
  - 欲しい本がオーディオブックになっているとは限らない
- **やりたいこと**
  - kindleの本を音読してほしい
  - 書籍代以外のお金はかけたくない
  - 専門書や小説を対象とし、漫画は対象外で良い

---

## 最初の実験

- **実験手順**
  1. Kindle本のテキストをテキストエディタにコピー。
  2. 次ページへページ移動して（１）を繰り返す。
  3. Macの「読み上げ」機能で読んでもらう。
- **反省点**
  1. コピーできる文字数に制限があった。
  2. ページが画像で作られたものがある（技術書に多い）。
  3. 面倒くさい。

---

## 読み聞かせてもらいたい

Macには自動で以下のことをしてもらう必要がある。

- 文字認識
  - Kindleの書籍画像を文字認識してテキストデータを抽出
  - 文字認識すれば画像の書籍でも問題ない。
- 読み上げ
  - いちいち、読み上げ機能を選択して実行したくない。
- 自ページへの移動
  - いちいち、次ページへの移動を操作したくない

---

### 文字認識

OCRエンジンである`tesseract`を利用することにした。
`tesseract`は、Googleが開発を後援しており、Apache License2.0で公開されている。

文字認識したいkindle本のキャプチャ画像を用意し、`tesseract`で文字認識する。

``` sh
> tesseract  [IMAGE_PATH] [OUTPUT_TEXT_PTH]  -l jpn_f
```

`tesseract`のgithubリポジトリ
<https://github.com/tesseract-ocr/tesseract>

---

### 読み上げ

macOSに搭載されている`say`コマンドを利用することにした。
文字認識したテキストデータはファイルに保存されるので、パイプを使って`say`コマンドにテキストデータを流し込む。

``` sh
> say "マックにKindleを読み上げてもらう"

> cat [TEXT_PATH] | say
```

Windowsの場合は、PowerShellを使えば同じことができる。

```cmd
(New-Object -ComObject SAPI.SpVoice).Speak("Windowsだって話せる")
```

---

### 次ページへ移動

Kindle本の画像があれば、文字認識して読み上げることが分かった。
Kindle本の画像取得や、ページ移動するには、AppleScriptを使う。

``` AppleScript
-- Kindleをアクティブにする（起動されていなければ起動する）
activate application "Kindle"
-- 画面キャプチャを取得しKindleの書籍部分のみを抽出する
do shell script "screencapture [capturedScreenPath]"
do shell script "/usr/local/bin/convert [capturePath] -crop [captureSize] [ImagePath]
-- ページ捲りを行う
tell application "Kindle"
    activate
    tell application "System Events"
        key code pageTurningDirection
    end tell
    delay 2
end tell
```

---

## MacにKindleを音読する

これまでに実施してきた「文字認識」「読み上げ」「次ページへ移動」を組み合わせることで、MacがKindle本を音読してくれる。

出来上がったコードは、[ココ](https://github.com/big-gate-0219/AppleScript/blob/main/KindlePageTurner.scpt)。

---

## もっと自然なイントネーションで

macOSの`say`コマンドは棒読みに毛が生えた程度の精度。
棒読みをずっと聞かされるのは辛いので対策する。

個人的に、Windows端末に[VOICEROID2 結月ゆかり](https://www.ah-soft.com/voiceroid/yukari/index.html)を導入しているので、`tesseract`でテキストかしたデータを音声化する。

VOICEROID2 結月ゆかりは、大人の女性の情感あふれる声でテキストを読み上げてくれるので、棒読みのイライラから解放された。

お金払えば、明るい女の子風に読んでもらったり、可愛い男の子の声で呼んでもらったり、秘密結社鷹の爪団の吉田くんに読んでもらったりもできるよ。

---

## スマホでも音読データを

macがないと音声で聞けないのも嬉しくないので、mp3化も図る。

VOICEROID2はwaveファイルで音声データが出力されるので、容量圧縮のため[ffmpeg](https://ffmpeg.org/)コマンドでmp3ファイルに変換。

mp3ファイルをスマホに保存すれば、スマホ上でもKindleを見ながら音声を聞ける。

---

### おしまい

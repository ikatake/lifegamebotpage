# ライフゲームbot
<div id="lgbplayer" align="center">
life game bot player<br />
<img id="stateimg" width="100px" height="100px" /><br />
gene:<input type="text" id="gene">
step:<input type="text" id="step">
<input type="button" id="jump" value="jump" onclick="jump()">
<br />
<input type="button" id="prev" value="|&lt;|&lt;|" onclick="prev()">
<input type="button" id="play" value="|&gt;" onclick="play()">
<input type="button" id="next_step" value="|&gt;|" onclick="increase()">
<input type="button" id="next_gene" value="|&gt;|&gt;|" onclick="next()">
<input type="button" id="shuffle" value="shuffle off" onclick="shuffle()">
<input type="button" id="repeat" value="repeat off" onclick="repeat()">
</div>
## 概要
+ [Twitterでライフゲームし続けるbotです。](https://twitter.com/_lifegamebot)
+ 1ステップ/15分、10x10セル。
+ ツイート最終行のgは世代で初期化すると+1されます。sはステップ数で、初期化すると0に戻ります。
+ [init](https://twitter.com/intent/tweet?source=webclient&text=%40_lifegamebot+init)ってreplyを受け取ると、初期化します。

## ライフゲームとは
+ 詳しくは[wikipediaのページ](http://ja.wikipedia.org/wiki/%E3%83%A9%E3%82%A4%E3%83%95%E3%82%B2%E3%83%BC%E3%83%A0)でも見てください。
+ また、[ニコニコ大百科にもページ](http://dic.nicovideo.jp/id/27645)があります。
+ セルオートマトン楽しいよ。

## 管理
ライフゲームbotは[いかたけ](http://ikatake.hateblo.jo)([@ikatake](https://twitter.com/ikatake/))が作成し、[しめり蒸気](http://wetsteam.org/)によって管理されています。

## 直近5世代のGIF動画
<p id="newgifs"> </p>


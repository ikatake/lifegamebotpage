var pathCgi = './lgbplayer.cgi';
var handleContent;
var req;
var divNode;
var obj, newest;
var ancImg;
var arlen;
var pauseState, repeatState, shuffleState;
var intvID;
var elTwtStep, elTwtGene, elPlayButton, elRepeatButton, elShuffleButton;
var elPlayButtonImage, elShuffleButtonImage, elRepeatButtonImage;
var shirtColor;
//ページ読み込み時の処理を行う。
function proc_onload() {
	//通信用オブジェクト
	req = new XMLHttpRequest();
	//contentに紐付け。
	/*
	handleContent = document.getElementById('lgbplayer');
	var div = document.createElement('div');
	divNode = handleContent.appendChild(div);
	*/
	elTwtStep = document.getElementById('tweet_step_pb');
	elTwtGene = document.getElementById('tweet_gene_pb');
	ancImg = document.getElementById('stateimg');
	elPlayButton = document.getElementById('play');
	elRepeatButton = document.getElementById('repeat');
	elShuffleButton = document.getElementById('shuffle');
	elPlayButtonImage = elPlayButton.firstChild;
	elShuffleButtonImage = elShuffleButton.firstChild
	elRepeatButtonImage = elRepeatButton.firstChild;
	//サーバ側が準備出来たら、readData関数を呼ぶ。
	req.onreadystatechange = readData;
	obj = new State();
	//要求を送る
	req.open("get", pathCgi+"?call=reload", true);
	req.send("");
	setPauseState(true);
	setShuffleState(false);
	setRepeatState("one");
}
function proc_onload_measure() {
	req = new XMLHttpRequest();
	req.onreadystatechange = readDataMeasure;
	req.open("get", pathCgi+"?call=measure", true);
	req.send("");
}
function t_shirt_pb(color) {
	shirtColor = color;
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	var add = "product.rb?material=t_shirt&gene=" + gene;
	add = add + "&step=" + step + "&color=" + color;
	window.open(add, "t_shirt.rb");
/*
	req = new XMLHttpRequest();
	req.onreadystatechange = readDataWear;
	req.open("get", pathCgi+"?call=jump&gene="+gene+"&step="+step, true);
	req.send("");
*/
}
function sticker_pb(color) {
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	var add = "product.rb?material=sticker&gene=" + gene;
	add = add + "&step=" + step + "&color=" + color;
	window.open(add, "sticker.rb");
}
function can_badge_pb(color) {
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	var add = "product.rb?material=can_badge&gene=" + gene;
	add = add + "&step=" + step + "&color=" + color;
	window.open(add, "can_badge.rb");
}
function handkerchief_pb(color) {
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	var add = "product.rb?material=handkerchief&gene=" + gene;
	add = add + "&step=" + step + "&color=" + color;
	window.open(add, "handkerchief.rb");
}
function hoodie_pb(color) {
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	var add = "product.rb?material=hoodie&gene=" + gene;
	add = add + "&step=" + step + "&color=" + color;
	window.open(add, "hoodie.rb");
}
function jump() {
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	if( jump2(gene, step) == -1){
//		alert("shit!");
	}
}
function jump2(gene, step) {
	if( isExist(gene, step) != true ) {
		return -1;	
	}
	obj.gene = gene;
	obj.step = step;
	setImg(gene, step);
	setTweetButton(gene, step);
	setValue('gene', obj.gene);
	setValue('step', obj.step);
	return 0;
}
function play() {
	if(pauseState == true) {
		setPauseState(false);
	} else {
		setPauseState(true);
	}
}
function increase() {
	if(obj.step < (arlen[obj.gene] - 1) ) {//今のstepはケツではない
		jump2(obj.gene, obj.step+1);
	} else {//ケツです。
		if(repeatState == "one") {//repeatoneで繰り返し。
			jump2(obj.gene, 0);
		}
		else if(repeatState == "all") {//repeatallでnextする。
			next();
		}
	}
}
function prev() {
	setPauseState(true);
	if(obj.step == 0) {
		var gene = obj.gene;
		while(1) {
			gene--;
			if(-1 != jump2(gene, 0)) {
				break;
			}
		}
	} else {
		jump2(obj.gene, 0);
	}
}
function next() {
	//
	var gene = undefined;
	var rtn;
	if(shuffleState == true) {
		while(1) {
			gene = Math.floor(Math.random()*newest.gene) + 1;
			if(-1 != jump2(gene, 0)) {
				break;
			}
		}
	} else if(obj.gene == newest.gene) {
		if(repeatState == "all") {
			jump2(1, 0);
		}
	} else {
		gene = obj.gene;
		while(1) {
			gene++;
			if(-1 != jump2(gene, 0)) {
				break;
			}
		}
	}
}
function shuffle() {
	if(shuffleState == true) {
		setShuffleState(false);
	} else {
		setShuffleState(true);
	}
}
function repeat() {
	if(repeatState == "all") {
		setRepeatState("off");
	} else if(repeatState == "one") {
		setRepeatState("all");
	} else {
		setRepeatState("one");
	}
}
function setPauseState(_pauseState) {
	if(pauseState == _pauseState) {
		return;
	}
	pauseState = _pauseState;
	if(pauseState == true) {
		clearInterval(intvID);
		elPlayButton.style.backgroundColor = "#FFFFFF";
		elPlayButtonImage.setAttribute("title", "停止中");
	} else {
		intvID = setInterval(function() { increase(); }, 500);
		elPlayButton.style.backgroundColor = "#2E8B57";
		elPlayButtonImage.setAttribute("title", "再生中");
	}
}
function setShuffleState(_shuffleState) {
	if(shuffleState == _shuffleState) {
		return;
	}
	shuffleState = _shuffleState;
	if(shuffleState == true) {
		elShuffleButton.style.backgroundColor = "#2E8B57";
		elShuffleButtonImage.setAttribute("title", "シャッフル　オン");
	} else {
		elShuffleButton.style.backgroundColor = "#FFFFFF";
		elShuffleButtonImage.setAttribute("title", "シャッフル　オフ");
	}
}
function setRepeatState(_repeatState) {
	if(repeatState == _repeatState) {
		return;
	}
	repeatState = _repeatState;
	if(repeatState == "all") {
		elRepeatButton.style.backgroundColor = "#2E8B57";
		elRepeatButtonImage.setAttribute("src", "./lgbpimg/repeatALL.png");
		elRepeatButtonImage.setAttribute("title", "リピート(全て)");
	} else if(repeatState == "one") {
		elRepeatButton.style.backgroundColor = "#2E8B57";
		elRepeatButtonImage.setAttribute("src", "./lgbpimg/repeat1.png");
		elRepeatButtonImage.setAttribute("title", "リピート(世代)");
	} else {
		elRepeatButton.style.backgroundColor = "#FFFFFF";
		elRepeatButtonImage.setAttribute("src", "./lgbpimg/repeat.png");
		elRepeatButtonImage.setAttribute("title", "リピート　オフ");
	}
}
//受信用関数
function readData() {
	if(req.readyState == 4) {
		newest = JSON.parse(req.responseText);
		console.log(newest);
		newest.gene = parseInt(newest.gene);
		newest.step = parseInt(newest.step);
		//表示用文字列を生成
		/*
		var str = "gene:" + newest.gene + "  ";
		str += "step:" + newest.step;
		var div = document.createElement('div');
		handleContent.removeChild(divNode);
		divNode = handleContent.appendChild(div);
		div.innerHTML = str;
		*/
		setValue('gene', newest.gene);
		setValue('step', newest.step);
		arlen = new Array();
		arlen[newest.gene] = newest.step;
		setGifs();
		proc_onload_measure();
	}
}
function readDataMeasure() {
	if(req.readyState == 4) {
		var tmp_obj = JSON.parse(req.responseText);
		console.log(tmp_obj);
		for(var ii = 0; ii < tmp_obj.length; ii++) {
			var gene = parseInt(tmp_obj[ii].gene);
			var len = parseInt(tmp_obj[ii].length);
			arlen[gene] = len;
		}
		jump2(parseInt(newest.gene), parseInt(newest.step));
	}
}
function setImg(gene, step) {
	var fname = "http://www.wetsteam.org/lifegamebot/stateLogs/";
	fname += ("00000000" + gene).slice(-8) + "/"; 
	fname += ("00000000" + step).slice(-8) + ".svg";
	ancImg.setAttribute("src", fname);
	ancImg.setAttribute("alt", "g:" + gene + ", s:" + step);
}
function setGifs()
{
	var anc = document.getElementById('newgifs');
	var gifimgs = anc.children;
	for(var ii = 1; ii <= 5 && newest.gene - ii > 0; ii++)
	{
		//var img = document.createElement('img');
		var fname = "http://www.wetsteam.org/lifegamebot/gifs/";
		var gene = newest.gene - ii;
		fname += ("00000000" + gene).slice(-8) + ".gif";
		//img.setAttribute("src", fname);
		//img.setAttribute("alt", gene);
		gifimgs[ii-1].setAttribute("src", fname);
		gifimgs[ii-1].setAttribute("alt", gene);
		gifimgs[ii-1].setAttribute("title", gene);
		//anc.appendChild(img);
	}
}
/*
	getValue : 指定したDOM要素の値を取得する
	element : 取得するDOM要素のid
	戻り値 : 指定したDOM要素の値。
*/
function getValue(element) {
	var elem = document.getElementById(element);
	if(null == elem) {
		console.log("funtion getValue\t"+element+"is null\n");
		return null;
	}
	return elem.value;
}
/*
	setvalue : DOM要素に指定の値を書き込む。
	element : 値を書き込むDOM要素のid
	value : 値
	戻り値 : DOM要素が無ければnull、それ以外は1。
*/
function setValue(element, value) {
	var elem = document.getElementById(element);
	if(null == elem) {
		console.log("funtion setValue\t"+element+"is null\n");
		return null;
	}
	elem.value = value;
	return 0;
}
/*
	inExist : 指定のgene, stepがstateLogにあるか確認する。
	gene, step : 世代とステップ数の数値
	戻り値 : 存在していればtrue。無ければfalse
*/
function isExist(gene, step) {
	if(gene > newest.gene) {
		return false;
	}
	if(step < arlen[gene]) {
		return true;
	} else {
		return false;
	}
	return undefined;
}
function setTweetButton(gene, step) {
	var txHref = "https://twitter.com/intent/tweet?source=webclient&amp;";
	var txStep = txHref + "text=LifeGameBot(@_lifegamebot)%0d%0a";
	var txGene = txStep;
	var strAdd  = "http://www.wetsteam.org/lifegamebot/";
	var strStep = ("00000000" + step).slice(-8);
	var strGene = ("00000000" + gene).slice(-8);
	txStep += "gene:" + gene + " step:" + step + "%0d%0a";
	txGene += "gene:" + gene + "%0d%0a";
	txStep += strAdd + "stateLogs/" + strGene + "/" + strStep + ".svg%0d%0a";
	txGene += strAdd + "gifs/" + strGene + ".gif";
	txStep = "window\.open\(\'" + txStep + "\'\)";
	txGene = "window\.open\(\'" + txGene + "\'\)";
	if(elTwtStep != undefined) {
		elTwtStep.setAttribute('onclick', txStep);
	}
	if(elTwtGene != undefined) {
		elTwtGene.setAttribute('onclick', txGene);
		if(gene >= newest.gene) {
			elTwtGene.setAttribute('disabled', "disabled");
		} else {
			elTwtGene.removeAttribute('disabled');

		}
	}
}
function State() {
	this.gene = undefined;
	this.step = undefined;
}
//ページ読み込み時にproc_onloadを起動。
window.onload=proc_onload;
function setArrayState(ar, str) {
	var ii = 0;
	var idx = 0;
	while(str.charAt(ii) != '') {
		if(str.charAt(ii) == '1') {
			ar[idx] = true;
			idx++;
		}
		else if(str.charAt(ii) == '0') {
			ar[idx] = false;
			idx++
		}
		ii++;
	}
}

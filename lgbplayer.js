var pathCgi = './lgbplayer.cgi';
var handleContent;
var req, req2;
var divNode;
var obj, newest;
var ancImg;
var arlen;
var pauseState, repeatState, shuffleState;
var intvID; 

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
	ancImg = document.getElementById('stateimg');
	//サーバ側が準備出来たら、readData関数を呼ぶ。
	req.onreadystatechange = readData;
	obj = new State();
	//要求を送る
	req.open("get", pathCgi+"?call=reload", true);
	req.send("");
	setPauseState(true);
	setShuffleState(false);
	setRepeatState("off");
}
function proc_onload_measure() {
	req = new XMLHttpRequest();
	req.onreadystatechange = readDataMeasure;
	req.open("get", pathCgi+"?call=measure", true);
	req.send("");
}
function jump() {
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	if( jump2(gene, step) == -1){
		alert("shit!");
	}
}
function jump2(gene, step) {
	if( isExist(gene, step) != true ) {
		return -1;	
	}
	obj.gene = gene;
	obj.step = step;
	setImg(gene, step);
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
		jump2(obj.gene - 1, 0);
	} else {
		jump2(obj.gene, 0);
	}
}
function next() {
	//
	var gene = undefined;
	if(shuffleState == true) {
		gene = Math.floor(Math.random()*newest.gene) + 1;
	} else if(obj.gene == newest.gene) {
		if(repeatState == "all") {
			gene = 1;
		}
	} else {
		gene = obj.gene + 1;
	}
	if(gene != undefined) {
		jump2(gene, 0);
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
		setValue("play", "|>");
	} else {
		intvID = setInterval(function() { increase(); }, 500);
		setValue("play", "||");
	}
}
function setShuffleState(_shuffleState) {
	if(shuffleState == _shuffleState) {
		return;
	}
	shuffleState = _shuffleState;
	if(shuffleState == true) {
		setValue("shuffle", "shuffle on");
	} else {
		setValue("shuffle", "shuffle off");
	}
}
function setRepeatState(_repeatState) {
	if(repeatState == _repeatState) {
		return;
	}
	repeatState = _repeatState;
	if(repeatState == "all") {
		setValue("repeat", "repeat all");
	} else if(repeatState == "one") {
		setValue("repeat", "repeat one");
	} else {
		setValue("repeat", "repeat off");
	}
}
//受信用関数
function readData() {
	if(req.readyState == 4) {
		newest = JSON.parse(req.responseText);
		console.log(newest);
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
	var fname = "./stateLogs/";
	fname += ("00000000" + gene).slice(-8) + "/"; 
	fname += ("00000000" + step).slice(-8) + ".svg";
	ancImg.setAttribute("src", fname);
	ancImg.setAttribute("alt", "g:" + gene + ", s:" + step);
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
function State() {
	this.gene = undefined;
	this.step = undefined;
}
//ページ読み込み時にproc_onloadを起動。
window.onload=proc_onload;


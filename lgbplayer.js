var pathCgi = './lgbplayer.cgi';
var handleContent;
var req;
var divNode;
var obj, newest;
var ancImg;
var arlen;
var pauseState, repeatState, shuffleState;
var intvID;
var elTwtStep, elTwtGene, elPlayButton, elRepeatButton, elShuffleButton, elRepeatButtonImage;
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
	elRepeatButtonImage = elRepeatButton.firstChild;
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
function wear_pb(color) {
	shirtColor = color;
	var gene = parseInt(getValue('gene'));
	var step = parseInt(getValue('step'));
	req = new XMLHttpRequest();
	req.onreadystatechange = readDataWear;
	req.open("get", pathCgi+"?call=jump&gene="+gene+"&step="+step, true);
	req.send("");
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
function makeWear(gene, step, state) {
	var elSvg = document.getElementById('suzuri_svg');
	var yBottomText, yCellTop;
	var wTopText, wBottomText1, wBottomText2;
	var wArea, hArea;
	var hCells;
	var arState = new Array();
	const SIZE_CELL = 10;
	const W_LINE = 1;
	const X_STATE = 0;
	const X_TEXT = 0;
	const MARGIN_T = 10;
	const MARGIN_B = 10;
	const MARGIN_L = 10;
	const MARGIN_R = 10;
	const SPC_CELL = 2;
	const SPC_T = 2;
	const SPC_B = 0;
	const NUM_CELLS = 10;
	const H_TOP_TEXT = 18;
	const H_BTM_TEXT1 = 18;
	const H_BTM_TEXT2 = 18;
	const W_CHR_TEXT = 10;
	const NS = "http://www.w3.org/2000/svg";
	//
	while(elSvg.firstChild) {
		elSvg.removeChild(elSvg.firstChild);
	}
	setArrayState(arState, state);
	if(shirtColor == 'black') {
		var clFore = 'green';
	} else {
		var clFore = 'black';
	}
	//雑にwidthとheightを決める。
	setSizeSvg(elSvg, 200, 200);
	//テキスト生成
	var elBgRect = document.createElementNS(NS, 'rect');
	var elTopText = document.createElementNS(NS, 'text');
	var elBottomText1 = document.createElementNS(NS, 'text');
	var elBottomText2 = document.createElementNS(NS, 'text');
	//appendChild
	elSvg.appendChild(elBgRect);
	elSvg.appendChild(elTopText);
	elSvg.appendChild(elBottomText1);
	elSvg.appendChild(elBottomText2);
	//テキストの情報を設定
	setTextElementSvg(elTopText, '@_lifegamebot', clFore);
	wTopText = W_CHR_TEXT * elTopText.textContent.length;
	setTextElementSvg(elBottomText1, 'gene:' + gene, clFore);
	setTextElementSvg(elBottomText2, 'step:' + step, clFore);
	wBottomText1 = W_CHR_TEXT * elBottomText1.textContent.length;
	wBottomText2 = W_CHR_TEXT * elBottomText2.textContent.length;
	yCellTop = MARGIN_T + H_TOP_TEXT + SPC_T;
	hCells = (SPC_CELL + SIZE_CELL) * NUM_CELLS - SPC_CELL;
	yBottomText1 = yCellTop + hCells + SPC_B + H_BTM_TEXT1;
	yBottomText2 = yBottomText1 + H_BTM_TEXT2;
	//SVGのサイズを計算
	wText = max3(wTopText, wBottomText1, wBottomText2);
	wArea = MARGIN_L + (SPC_CELL + SIZE_CELL) * NUM_CELLS + MARGIN_R;
	wArea = max3(0, wArea, MARGIN_L + wText + MARGIN_R);
	hArea = yBottomText2 + MARGIN_B;
	//BackGround
	setXywhSvg(elBgRect, 0, 0, wArea, hArea);
	elBgRect.setAttribute('style', 'fill:rgba\(255,255,255,0.0\)');
	//テキストの位置を設定
	setPosSvg(elTopText, MARGIN_L, MARGIN_T + H_TOP_TEXT * 0.75);
	setPosSvg(elBottomText1, MARGIN_L, yBottomText1 - H_BTM_TEXT1 * 0.25);
	setPosSvg(elBottomText2, MARGIN_L, yBottomText2 - H_BTM_TEXT2 * 0.25);
	//Cells
	for(var ii = 0; ii < NUM_CELLS; ii++) {
		var y = yCellTop + ii * (SIZE_CELL + SPC_CELL);
		for(var jj = 0; jj < NUM_CELLS; jj++) {
			var elCellRect  = document.createElementNS(NS, 'rect');
			var x = MARGIN_L + jj * (SIZE_CELL + SPC_CELL);
			setXywhSvg(elCellRect, x, y, SIZE_CELL, SIZE_CELL);
			var style = "";
			style = 'stroke:' + clFore + ';stroke-width:' + W_LINE;
			if(arState[ii * NUM_CELLS + jj]) {
				style += ';fill:' + clFore;
			} else {
				style += ';fill:rgba(255,255,255,0.0)';
			}
			elCellRect.setAttribute('style', style);
			elSvg.appendChild(elCellRect)
		}
	}
	setSizeSvg(elSvg, wArea * 10, hArea * 10);
	elSvg.setAttribute('viewBox', '0 0 ' + wArea + ' ' + hArea );
	var elCanvas = document.getElementById('suzuri_canvas');
	var svgData = new XMLSerializer().serializeToString(elSvg);
	elCanvas.width = wArea * 10;
	elCanvas.height = hArea * 10;
	var ctx = elCanvas.getContext('2d');
	imgsrc = 'data:image/svg+xml;charset=utf-8;base64,'
		+ btoa(unescape(encodeURIComponent(svgData)));
	var image = new Image();
	image.src = imgsrc;
	image.onload = function() {
		ctx.drawImage(image, 0, 0);
		elSvg.setAttribute('style', 'display:none');
		sendWear(gene, step);
	}
}
function setTextElementSvg(elText, strTextContent, colorText) {
	elText.setAttribute('font-family', 'Courier New, Courier');
	elText.setAttribute('font-size', '16');
	elText.setAttribute('fill', colorText);
	elText.textContent = strTextContent;
}
function setPosSvg(element, x, y) {
	element.setAttribute('x', x + 0);
	element.setAttribute('y', y + 0);
}
function setSizeSvg(element, w, h) {
	element.setAttribute('width', w + 0);
	element.setAttribute('height', h + 0);
}
function setXywhSvg(element, x, y, w, h) {
	setPosSvg(element, x, y);
	setSizeSvg(element, w, h);
}
function max3(x1, x2, x3) {
	if( (x1 >= x2) && (x1 >= x2) ) {
		return x1;
	}
	else if( (x2 >= x1) && (x2 >= x3) ) {
		return x2;
	}
	return x3;
}
function sendWear(gene, step, color){
	var elCanvas = document.getElementById('suzuri_canvas');
	var xhr = new XMLHttpRequest();
	var itemId = 151;
	if(shirtColor == 'black') {
		itemId = 152;
	}
	var sendData = {
		'title' : '@_lifegamebot g:' + gene + ' s:' + step,
		'texture' : elCanvas.toDataURL('image/png'),
		'price' : 0,
		'description' : '@_lifegamebot g:' + gene + ' s:' + step,
		'products' : [ 
		{
			'itemId' : 1,
			'exemplaryItemVariantId' :  itemId,
			'published' : true,
			'resizeMode' : 'contain'
		} ] };
	xhr.onload = function() {
		console.log(xhr);
		if(xhr.status != 200) {
			alert("なんか失敗したっぽい");
			return 1;
		}
		var url = xhr.response.products[0].sampleUrl;
		if(url != null && url != "") {
			window.open(url, 'suzuri');
		} else {
			alert("なんか失敗したっぽい");
			return 1;
		}
	};
	xhr.open('POST', 'https://suzuri.jp/api/v1/materials', true);
	xhr.setRequestHeader("Content-Type", "application/json");
	xhr.setRequestHeader('Authorization', 'Bearer ' + suzuriApiKey);
	xhr.responseType = 'json';
	console.log(sendData);
	xhr.send(JSON.stringify(sendData));
	elCanvas.setAttribute('hidden', 'hidden');
}
	
function setPauseState(_pauseState) {
	if(pauseState == _pauseState) {
		return;
	}
	pauseState = _pauseState;
	if(pauseState == true) {
		clearInterval(intvID);
		//setValue("play", "|>");
		elPlayButton.style.backgroundColor = "#FFFFFF";
	} else {
		intvID = setInterval(function() { increase(); }, 500);
		//setValue("play", "||");
		elPlayButton.style.backgroundColor = "#2E8B57";
	}
}
function setShuffleState(_shuffleState) {
	if(shuffleState == _shuffleState) {
		return;
	}
	shuffleState = _shuffleState;
	if(shuffleState == true) {
		//setValue("shuffle", "shuffle on");
		elShuffleButton.style.backgroundColor = "#2E8B57";
	} else {
		//setValue("shuffle", "shuffle off");
		elShuffleButton.style.backgroundColor = "#FFFFFF";
	}
}
function setRepeatState(_repeatState) {
	if(repeatState == _repeatState) {
		return;
	}
	repeatState = _repeatState;
	if(repeatState == "all") {
		//setValue("repeat", "repeat all");
		elRepeatButton.style.backgroundColor = "#2E8B57";
		elRepeatButtonImage.setAttribute("src", "./lgbpimg/repeatAll.png");
	} else if(repeatState == "one") {
		//setValue("repeat", "repeat one");
		elRepeatButton.style.backgroundColor = "#2E8B57";
		elRepeatButtonImage.setAttribute("src", "./lgbpimg/repeat1.png");
	} else {
		//setValue("repeat", "repeat off");
		elRepeatButton.style.backgroundColor = "#FFFFFF";
		elRepeatButtonImage.setAttribute("src", "./lgbpimg/repeat.png");
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
function readDataWear() {
	if(req.readyState == 4) {
		var stateWear = JSON.parse(req.responseText);
		var gene = parseInt(stateWear.gene);
		var step = parseInt(stateWear.step);
		makeWear(gene, step, stateWear.state);
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
        for(var ii = 1; ii <= 5; ii++)
        {
                var img = document.createElement('img');
                var fname = "http://www.wetsteam.org/lifegamebot/gifs/";
                var gene = newest.gene - ii;
                fname += ("00000000" + gene).slice(-8) + ".gif";
                img.setAttribute("src", fname);
                img.setAttribute("alt", gene);
                anc.appendChild(img);
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

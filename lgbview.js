var pathCgi = './lgbview.cgi?param=';
var handleContent;
var req;
var divNode;
var obj;
var ancImg;

//ページ読み込み時の処理を行う。
function proc_onload() {
	//通信用オブジェクト
	req = new XMLHttpRequest();
	//contentに紐付け。
	handleContent = document.getElementById('lgbviewer');
	var div = document.createElement('div');
	divNode = handleContent.appendChild(div);
	ancImg = document.getElementById('lgbimg');
	reqData();
}


//送信要求用関数
function reqData() {
	//サーバ側が準備出来たら、readData関数を呼ぶ。
	req.onreadystatechange = readData;
	//要求を送る
	req.open("get", pathCgi, true);
	req.send("");
}

//受信用関数
function readData() {
	if(req.readyState == 4) {
		obj = JSON.parse(req.responseText);
		console.log(obj);
		//表示用文字列を生成	
		var str = "gene:" + obj.gene + "  ";
		str += "step:" + obj.step;
		var div = document.createElement('div');
		handleContent.removeChild(divNode);
		divNode = handleContent.appendChild(div);
		div.innerHTML = str;
		setImg();
		setGifs();
	}
}
function setImg()
{
	var fname = "./stateLogs/";
	fname += ("00000000" + obj.gene).slice(-8) + "/"; 
	fname += ("00000000" + obj.step).slice(-8) + ".svg";
	ancImg.setAttribute("src", fname);
	ancImg.setAttribute("alt", obj.state);
}
function setGifs()
{
	var anc = document.getElementById('newgifs');
	for(var ii = 1; ii <= 5; ii++)
	{
		var img = document.createElement('img');
		var fname = "./gifs/";
		var gene = obj.gene - ii;
		fname += ("00000000" + gene).slice(-8) + ".gif";
		img.setAttribute("src", fname);
		img.setAttribute("alt", gene);
		anc.appendChild(img);
	}
}


//ページ読み込み時にproc_onloadを起動。
window.onload=proc_onload;


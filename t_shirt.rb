#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby
###!/bin/usr/local/ruby

#Tシャツ作成用cgi

require_relative './suzuri_util.rb'
require_relative './lgb_util.rb'
require_relative './draw_rmagick.rb'
require 'rmagick'
require 'cgi'
require 'date'
include Math

print "Content-Type: text/html\n\n"
print "<html><head><title>nyan</title></head><body>\n"
cgi = CGI.new
text = CGI.escapeHTML cgi["t"]
print text
print "<br>"

if (cgi.has_key?('color')  == false) 
  print "invalid parameters.(need 'color')."
  print "</body></html>\n"
  exit 0
end
if (cgi.has_key?('gene') ^ cgi.has_key?('step'))
  print "invalud parameters.(need both 'gene' and 'step')"
  print "</body></html>\n"
  exit 0
end

#read argument (color)
if(cgi['color'] == "black")
  color = "black"
else
  color = "white"
end

#read argument (gene and step)
if (cgi.has_key?('gene') && cgi.has_key?('step'))
  gene = cgi['gene'].to_i
  step = cgi['step'].to_i
	p gene
	p step
  if( is_valid_gene_step?(gene, step) == false)
    print "invalid gene or step."
    print "</body></html>\n"
    exit 0
  end
  state = get_state_text(gene, step)
else #nothing gene & step => get lastst state
  state = get_lastest_state_text
  arr = get_lastest_gene_step
  gene = arr[0]
  step = arr[1]
end

#make iamge file
file_name = "t_shirt_img/" + gene.to_s + "_" + step.to_s + "_"
file_name += Time.now.to_i.to_s + ".png"
	p file_name

#set image file size
cell_size = 100
margin_top = 100
margin_btm = 100
space_top_text = 20
space_bottom_text = 0
cell_margin = 20
margin_left = 100
margin_right = 100
width_char = 100
line_width = 10
height_text = 180
num_cells = 10 

#set position of top text, cell_field and bottom texts
y_top_text = margin_top
y_cells = y_top_text + h_top_text + space_top
cell_field_size = cell_size * num_cells + cell_margin * (num_cells - 1)
y_bottom_text1 = y_cells + cell_field_size + h_bottom_text
y_bottom_text2 = y_bottom_text1 + h_bottom_text
img_size = y_bottom_text2 + margin
#
str_top = '@_lifegamebot'
str_bottom1 = "step:#{step}"
str_bottom2 = "gene:#{gene}"
str_length = [str_top.length, str_bottom1.length, str_bottom2.length].max
str_width = char_width * str_length
img_width = [(margin_left + cell_field_size + margin_right), str_width].max 

img_size = 992   #img canvas size[px] (both width and height)

if(color == "white")
  color_bg = "#ffffff"
  color_front = "#000000"
elsif(color == "black")
  color_bg = "#000000"
  color_front = "#00ff00"
end
img = Magick::Image.new(img_size, img_size){self.background_color=color_bg}
draw_state(img, cell_size, cell_margin, line_width, margin_left, y_cells,
  color_bg, color_front, state)
width_char = 38 #1文字の幅[px]。tuning要素
font_size = 80 #文字サイズ。tuning要素

font = './font/mplus-2m-bold.ttf'

img.write(file_name)

img_address = "http://www.wetsteam.org/lifegamebot/" + file_name
print %Q{<span style="color:white"}
ret = suzuri( img_address, gene, step, "can_badge")
print %Q{</span>}
p ret
if(ret[0] == "3" || ret[0] == "4" || ret[0] == "5")
  print "</br>生成に失敗しました。さようなら。</br>\n"
  print %Q{<script type="text/javascript">\n}
  print %Q{<!-- \nwindow.open('about:_blank','_self').close()\n -->\n}
  print %Q{</script>\n}
else
  print %Q{<script type="text/javascript">\n}
  print %Q{<!-- \nwindow.location.href='#{ret}'\n -->\n}
  print %Q{</script>\n}
end
print "</body></html>\n"
#send to suzuri


#function makeWear(gene, step, state) {
#	var elSvg = document.getElementById('suzuri_svg');
#	var yBottomText, yCellTop;
#	var wTopText, wBottomText1, wBottomText2;
#	var wArea, hArea;
#	var hCells;
#	var arState = new Array();
#	//
#	while(elSvg.firstChild) {
#		elSvg.removeChild(elSvg.firstChild);
#	}
#	setArrayState(arState, state);
#	setTextElementSvg(elTopText, '@_lifegamebot', clFore);
#	wTopText = W_CHR_TEXT * elTopText.textContent.length;
#	setTextElementSvg(elBottomText1, 'gene:' + gene, clFore);
#	setTextElementSvg(elBottomText2, 'step:' + step, clFore);
#	wBottomText1 = W_CHR_TEXT * elBottomText1.textContent.length;
#	wBottomText2 = W_CHR_TEXT * elBottomText2.textContent.length;
#	yCellTop = MARGIN_T + H_TOP_TEXT + SPC_T;
#	hCells = (SPC_CELL + SIZE_CELL) * NUM_CELLS - SPC_CELL;
#	yBottomText1 = yCellTop + hCells + SPC_B + H_BTM_TEXT1;
#	yBottomText2 = yBottomText1 + H_BTM_TEXT2;
#	//SVGのサイズを計算
#	wText = max3(wTopText, wBottomText1, wBottomText2);
#	wArea = MARGIN_L + (SPC_CELL + SIZE_CELL) * NUM_CELLS + MARGIN_R;
#	wArea = max3(0, wArea, MARGIN_L + wText + MARGIN_R);
#	hArea = yBottomText2 + MARGIN_B;
#	//BackGround
#	setXywhSvg(elBgRect, 0, 0, wArea, hArea);
#	elBgRect.setAttribute('style', 'fill:rgba\(255,255,255,0.0\)');
#	//テキストの位置を設定
#	setPosSvg(elTopText, MARGIN_L, MARGIN_T + H_TOP_TEXT * 0.75);
#	setPosSvg(elBottomText1, MARGIN_L, yBottomText1 - H_BTM_TEXT1 * 0.25);
#	setPosSvg(elBottomText2, MARGIN_L, yBottomText2 - H_BTM_TEXT2 * 0.25);
#	//Cells
#	for(var ii = 0; ii < NUM_CELLS; ii++) {
#		var y = yCellTop + ii * (SIZE_CELL + SPC_CELL);
#		for(var jj = 0; jj < NUM_CELLS; jj++) {
#			var elCellRect  = document.createElementNS(NS, 'rect');
#			var x = MARGIN_L + jj * (SIZE_CELL + SPC_CELL);
#			setXywhSvg(elCellRect, x, y, SIZE_CELL, SIZE_CELL);
#			var style = "";
#			style = 'stroke:' + clFore + ';stroke-width:' + W_LINE;
#			if(arState[ii * NUM_CELLS + jj]) {
#				style += ';fill:' + clFore;
#			} else {
#				style += ';fill:rgba(255,255,255,0.0)';
#			}
#			elCellRect.setAttribute('style', style);
#			elSvg.appendChild(elCellRect)
#		}
#	}
#}

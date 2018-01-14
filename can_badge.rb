#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby
###!/bin/usr/local/ruby

#缶バッヂ作成用cgi

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
file_name = "can_badge_img/" + gene.to_s + "_" + step.to_s + "_"
file_name += Time.now.to_i.to_s + ".png"
	p file_name

#set image file size
img_size = 992   #img canvas size[px] (both width and height)
field_size = 420 #
cell_size = 36
cell_margin = 6
line_width = 3
margin = (field_size - cell_margin * 9 - cell_size * 10) / 2
p = (img_size - field_size) * 0.5 + margin

if(color == "white")
  color_bg = "#ffffff"
  color_front = "#000000"
elsif(color == "black")
  color_bg = "#000000"
  color_front = "#00ff00"
end
img = Magick::Image.new(img_size, img_size){self.background_color=color_bg}
draw_state(img, cell_size, cell_margin, line_width, p, p,
  color_bg, color_front, state)
draw = Magick::Draw.new
draw.stroke('red')
draw.fill('transparent')
draw.stroke_width(1)
draw.circle( img_size * 0.5, img_size * 0.5, img_size * 0.5, img_size )
draw.draw(img)
radius = img_size * 0.37 #文字を並べる円の半径。tuning要素
width_char = 38 #1文字の幅[px]。tuning要素
font_size = 80 #文字サイズ。tuning要素

str = '@_lifegamebot'
font = './font/mplus-2m-bold.ttf'
theta0 = PI / 2 * 1
annotate_on_arc(img, str, width_char, radius, img_size / 2, img_size / 2, 
  theta0, font, color_front, 'transparent', font_size)
str = "step:#{step}"
theta0 = PI / 2 * 0
annotate_on_arc(img, str, width_char, radius, img_size / 2, img_size / 2, 
  theta0, font, color_front, 'transparent', font_size)
str = "gene:#{gene}"
theta0 = PI / 2 * 2
annotate_on_arc(img, str, width_char, radius, img_size / 2, img_size / 2, 
  theta0, font, color_front, 'transparent', font_size)
str = "'Life is Beautiful.'"
theta0 = PI / 2 * 3
annotate_on_arc(img, str, width_char * 0.75, radius, img_size / 2, img_size / 2, 
  theta0, font, color_front, 'transparent', font_size* 0.75)

img.write(file_name)

img_address = "http://www.wetsteam.org/lifegamebot/" + file_name
print %Q{<span style="color:white"}
ret = suzuri( img_address, gene, step, color, "can_badge")
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



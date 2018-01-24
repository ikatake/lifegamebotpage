#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby
###!/bin/usr/local/ruby

#Tシャツ作成用cgi

require_relative './suzuri_util.rb'
require_relative './product_common.rb'
require_relative './draw_rmagick.rb'
require 'rmagick'
require 'cgi'
require 'date'
include Math

cgi = CGI.new
arr = cgi_input(cgi)
gene = arr[0]
step = arr[1]
state = arr[2]
color = arr[3]

#make iamge file
file_name = "t_shirt_img/" + gene.to_s + "_" + step.to_s + "_"
file_name += Time.now.to_i.to_s + ".png"
	p file_name

#set image file size
cell_size = 100
margin_top = 100
margin_btm = 150
space_top_text = 100
space_bottom_text = -50
cell_margin = 20
margin_left = 100
margin_right = 100
width_char = 110
line_width = 10
height_text = 180
num_cells = 10 
font_size = 200 #文字サイズ。tuning要素

#set position of top text, cell_field and bottom texts
y_top_text = margin_top
y_cells = y_top_text + height_text + space_top_text
cell_field_size = cell_size * num_cells + cell_margin * (num_cells - 1)
y_bottom_text1 = y_cells + cell_field_size + space_bottom_text
y_bottom_text2 = y_bottom_text1 + height_text
#set image width
str_top = '@_lifegamebot'
str_bottom1 = "gene:#{gene}"
str_bottom2 = "step:#{step}"
str_length = [str_top.length, str_bottom1.length, str_bottom2.length].max
str_width = width_char * str_length + margin_right
img_width = [(margin_left + cell_field_size + margin_right), str_width].max 
img_height = y_bottom_text2 + height_text + margin_btm

if(color == "white")
  color_bg = "transparent"
  color_front = "#000000"
elsif(color == "black")
  color_bg = "transparent"
  color_front = "#00ff00"
end
font = './font/mplus-2m-bold.ttf'
img = Magick::Image.new(img_width, img_height){self.background_color=color_bg}
annotate(img, str_top, width_char * str_top.length, height_text,
  margin_left, y_top_text, font, color_front, 'transparent', font_size)
draw_state(img, cell_size, cell_margin, line_width, margin_left, y_cells,
  color_bg, color_front, state)
annotate(img, str_bottom1, width_char * str_bottom1.length, height_text,
  margin_left, y_bottom_text1, font, color_front, 'transparent', font_size)
annotate(img, str_bottom2, width_char * str_bottom2.length, height_text,
  margin_left, y_bottom_text2, font, color_front, 'transparent', font_size)

img.write(file_name)

img_address = "http://www.wetsteam.org/lifegamebot/" + file_name
print %Q{<span style="color:white"}
ret = suzuri( img_address, gene, step, color, "t_shirt")
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


#!/bin/usr/local/ruby
##!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby

#缶バッヂ作成用cgi

require_relative './suzuri_util.rb'
require_relative './lgb_util.rb'
require 'rmagick'
require 'cgi'
require 'date'

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
field_size = 700 #cellular field size[px] = img_size / sqrt(2)

cell_size = 60
cell_margin = 10
line_width = 4
margin = (field_size - cell_margin * 9 - cell_size * 10) / 2
x = (img_size - field_size) * 0.5 + margin
y = x

if(color == "white")
  color_bg = "#ffffff"
  color_front = "#000000"
elsif(color == "black")
  color_bg = "#000000"
  color_front = "#00ff00"
end
img = Magick::Image.new(img_size, img_size){self.background_color=color_bg}

color_stroke = color_front 

arr = state.split(/\\n/)
for line in arr do
  charr = line.split("")
  for ch in charr do
    if(ch == "0")
      color_fill = color_bg
    elsif(ch == "1")
      color_fill = color_front
    end
    #draw out rectangle
    draw = Magick::Draw.new
    draw.stroke(color_stroke)
    draw.stroke_width(line_width)
    draw.fill(color_fill)
    draw.rectangle(x, y, x + cell_size, y + cell_size)
    draw.draw(img)
    # 1セル分右にずらす
    x += cell_size + cell_margin
  end
  #左右位置を元に戻して、1段下にずらす。
  x = (img_size - field_size) * 0.5 + margin
  y += cell_size + cell_margin
end
#png.save(file_name)
img.write("r.png")

draw.annotate(img, 100, 100, 150, 150, "lifegamebot") do
  self.font = "Courier"
  self.fill = 'black'
  self.stroke = 'transparent'
  self.pointsize = 54
  self.gravity = Magick::NorthWestGravity
end

#img_address = "http://www.wetsteam.org/lifegamebot/" + file_name
#print %Q{<span style="color:white"}
#ret = suzuri( img_address, gene, step, "sticker")
#print %Q{</span>}
#p ret
#if(ret[0] == "3" || ret[0] == "4" || ret[0] == "5")
#  print "</br>生成に失敗しました。さようなら。</br>\n"
#  print %Q{<script type="text/javascript">\n}
#  print %Q{<!-- \nwindow.open('about:_blank','_self').close()\n -->\n}
#  print %Q{</script>\n}
#else
#  print %Q{<script type="text/javascript">\n}
#  print %Q{<!-- \nwindow.location.href='#{ret}'\n -->\n}
#  print %Q{</script>\n}
#end
print "</body></html>\n"
#send to suzuri


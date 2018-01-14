#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby

##!/home/ikatake/local/rbenv/shims/ruby

#ステッカー作成用cgi

require_relative './suzuri_util.rb'
require_relative './lgb_util.rb'
require 'cgi'
require 'date'
require 'chunky_png'

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
file_name = "sticker_img/" + gene.to_s + "_" + step.to_s + "_"
file_name += Time.now.to_i.to_s + ".png"
	p file_name
width = 630
height = 630
if(color == "white")#fill bg clear(white)
  png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
elsif(color == "black") #fill bg color(black)
  png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::BLACK)
end

cell_size = 50
cell_margin = 10
line_width = 4
top_margin = (height - cell_margin * 9 - cell_size * 10) / 2
left_margin = (width - cell_margin * 9 - cell_size * 10) / 2
color_green = ChunkyPNG::Color.rgb(0, 255, 0)
x0 = top_margin
y0 = left_margin

arr = state.split(/\\n/)
for line in arr do
  charr = line.split("")
  for ch in charr do
    #draw out rectangle
    x1 = x0 + cell_size
    y1 = y0 + cell_size
    if(color == "white")
      color_o = ChunkyPNG::Color::BLACK
    elsif(color == "black")
      color_o = color_green
    end
    png.rect(x0, y0, x1, y1, color_o, color_o)
    
    #draw inside rectangle
    x0i = x0 + line_width
    y0i = y0 + line_width
    x1i = x1 - line_width
    y1i = y1 - line_width
    if(ch == "0" && color == "white")
      #draw black stroke & no rect
      color_i = ChunkyPNG::Color::WHITE
    elsif(ch == "1" && color == "white")
      #draw black stroke & black rect
      color_i = ChunkyPNG::Color::BLACK
    elsif(ch == "0" && color == "black")
      #draw green stroke & black rect
      color_i = ChunkyPNG::Color::BLACK
    elsif(ch == "1" && color == "black")
      #draw green stroke & green rect
      color_i = color_green
    end
    png.rect(x0i, y0i, x1i, y1i, color_i, color_i)
    # 1セル分右にずらす
    x0 = x0 + cell_size + cell_margin
  end
  #左右位置を元に戻して、1段下にずらす。
  x0 = top_margin
  y0 = y0 + cell_size + cell_margin
end
png.save(file_name)

img_address = "http://www.wetsteam.org/lifegamebot/" + file_name
print %Q{<span style="color:white"}
ret = suzuri( img_address, gene, step, color, "sticker")
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


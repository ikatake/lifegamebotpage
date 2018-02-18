#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby

##!/home/ikatake/local/rbenv/shims/ruby

#ステッカー描画用

require 'chunky_png'

def draw_sticker(file_name, gene, step, color, state)
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
end

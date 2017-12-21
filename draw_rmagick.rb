#!/home/ikatake/local/rbenv/shims/ruby

#rmagickのImageにライフゲームの絵を描く

# img		Macick::Image object
# size		cell size[px]
# margin	margin between celluer[px]
# width		stroke width[px]
# x0, y0	initial position of drawing[px](first rect north-west point)
# bg_color	background color ex.:"#000000"
# fr_color	front color ex.:"#ffffff"
# state		lifegame state text
def draw_state(img, size, margin, width, x0, y0, bg_color, fr_color, state)
  x = x0
  y = y0
  draw = Magick::Draw.new
  arr = state.split(/\\n/)
  for line in arr do
    charr = line.split("")
    for ch in charr do
      if(ch == "0")
        color_fill = bg_color
      elsif(ch == "1")
        color_fill = fr_color
      end
      #draw rectangle
      draw.stroke(fr_color)
      draw.stroke_width(width)
      draw.fill(color_fill)
      draw.rectangle(x, y, x + size, y + size)
      # 1セル分右にずらす
      x += size + margin
    end
    #左右位置を元に戻して、1段下にずらす。
    x = x0
    y += size + margin
  end
  draw.draw(img)
end


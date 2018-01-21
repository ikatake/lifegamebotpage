#!/home/ikatake/local/rbenv/shims/ruby

#rmagickのImageにライフゲームの絵を描く

def draw_state(img, size, margin, width, x0, y0, bg_color, fr_color, state)
# img		Macick::Image object
# size		cell size[px]
# margin	margin between celluer[px]
# width		stroke width[px]
# x0, y0	initial position of drawing[px](first rect north-west point)
# bg_color	background color ex.:"#000000"
# fr_color	front color ex.:"#ffffff"
# state		lifegame state text
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

def annotate_on_arc(img, str, wc, r, x0, y0, theta0, font, fill, stroke, size)
# img 		rmagick draw Macick::Image object
# str		annotate string
# wc		width of one charator[px]
# r, x0 ,y0	radius and center point[px] of circle(arc)
# theta0	angle at center of string[rad]
# font, size	font familiy and font size[pt?]
# fill, stroke	color of font fill and stroke
  draw = Magick::Draw.new
  l = wc * str.length # l is length of string[px]
  angle_string = l / r  # [rad]
  angle_charactor = wc / r #[rad]
  charr = str.split("")
  ii = 0
  for ch in charr do
    theta_c0 = theta0 + angle_string * 0.5 - ii * angle_charactor
    #theta_c0 is angle of charactor annotate angle that used in calc x, y
    theta_cc = theta_c0 - 0.5  * angle_charactor
    #theta_cc is angle of charactor center angle that used in rotation
    x = x0 + r * cos(theta_c0)
    y = y0 - r * sin(theta_c0)
    ch = ch.gsub(/^@/, '\@')
    draw.annotate(img, wc, wc, x, y, ch) do
      self.font = font
      self.fill = fill
      self.stroke = stroke
      self.pointsize = size
      self.gravity = Magick::NorthWestGravity
      self.rotation = -1.0 * (theta_cc * 180 / PI - 90)
    end
    ii += 1;
  end
end

def annotate(img, str, w, h, x, y, font, fill, stroke, size)
  draw = Magick::Draw.new  
  str = str.gsub(/^@/, '\@')
  draw.annotate(img, w, h, x, y, str) do
    self.font = font
    self.fill = fill
    self.stroke = 'transparent'
    self.pointsize = size
    self.gravity = Magick::NorthWestGravity
  end
end


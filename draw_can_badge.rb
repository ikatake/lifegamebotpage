#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby
###!/bin/usr/local/ruby

#缶バッヂ描画用

require_relative './draw_rmagick.rb'
require 'rmagick'
include Math

def draw_can_badge(file_name, gene, step, color, state)
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
end


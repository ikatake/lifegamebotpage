#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby
###!/bin/usr/local/ruby

#パーカー描画用

require_relative './draw_rmagick.rb'
require 'rmagick'
require 'cgi'

def draw_hoodie(file_name, gene, step, color, state)
  #set image file size
  cell_size = 80
  margin_top = 0
  margin_btm = 600
  space_top_text = 70
  space_bottom_text = -40
  cell_margin = 20
  margin_left = 300
  margin_right = 100
  width_char = 110
  line_width = 10
  height_text = 140
  num_cells = 10 
  font_size = 150 #文字サイズ。tuning要素

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
    color_front = "#ffffff"
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
end

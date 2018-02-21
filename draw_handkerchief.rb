#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby
###!/bin/usr/local/ruby

#パーカー描画用

require_relative './draw_rmagick.rb'
require 'rmagick'
require 'cgi'

def draw_handkerchief(file_name, gene, step, color, state)
  #set image file size
  margin = 320
  cell_margin = 20
  line_width = 10
  num_cells = 10
  img_size = 2283 #from suzuri manual
  cell_size = img_size - 2 * margin - cell_margin * (num_cells - 1)
  cell_size = cell_size / num_cells

  if(color == "white")
    color_bg = "transparent"
    color_front = "#000000"
  elsif(color == "black")
    color_bg = "#000000"
    color_front = "#ffffff"
  end
  img = Magick::Image.new(img_size, img_size){self.background_color=color_bg}
  draw_state(img, cell_size, cell_margin, line_width, margin, margin,
    color_bg, color_front, state)
  img.write(file_name)
end

#!/usr/bin/ruby
require 'rmagick'

def get_state_text(gene, step)
  p gene
  p step
  # set filename
  genestr = sprintf("%08d", gene)
  stepstr = sprintf("%08d", step)
  filename = ENV['HOME'] + "/www/wetsteam/lifegamebot/stateLogs/"
  filename = filename + genestr  + "\/" + stepstr + ".txt"
  file = File.open(filename)
  text = file.read
  file.close
  
  lines = text.split(/\n/)
  r = "";
  10.times do |i|
    r += (lines[i] + '\n')
  end
  return r
end

def convert_img(state, mode)
  size_cell = 50;
  spc_cell = 10;
  num_cells = 10;
  spc_frame = 20;
  width_stroke = 3;
  len_img = size_cell * num_cells + spc_cell * ( num_cells - 1 ) + 2 * spc_frame
  canvas = Magick::ImageList.new
  if(mode == 'black')
    canvas.new_image(len_img, len_img) { self.background_color = "black" }
  else
    canvas.new_image(len_img, len_img) { self.background_color = "white" }
  end
  arr_state = state.split(/\\n/)
  p arr_state
  
  num_cells.times do |y|
    y0 = spc_frame + y * ( size_cell + spc_cell )
    y1 = y0 + size_cell
    num_cells.times do |x|
      x0 = spc_frame + x * ( size_cell + spc_cell )
      x1 = x0 + size_cell
      s = 0
      s = arr_state[y][x]  #セルの状態を得る
      rect_cell = Magick::Draw.new
      rect_cell.rectangle(x0, y0, x1, y1)
      if(mode == 'black' && s == '1')
        rect_cell.fill = "green"
      elsif(mode == 'white' && s == '1')
        rect_cell.fill = "black"
      end
      rect_cell.stroke_width = width_stroke
      if(mode == 'black')
        rect_cell.stroke = "green"
      elsif(mode == 'white')
        rect_cell.stroke = "black"
      end
      rect_cell.draw(canvas)
    end
  end
  canvas.write("test.png");
end

def send_wear(png, gene, step)
  p png
  p gene
  p step
end


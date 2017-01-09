#!/usr/bin/ruby
require 'rmagick'
require 'time'
require 'fileutils'

def convert_img_sticker(state, mode)
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
      s = arr_state[y][x]  #セルの状態を得る
      rect_cell = Magick::Draw.new
      rect_cell.rectangle(x0, y0, x1, y1)
      if(mode == 'black' && s == '1') #塗潰しの標準は黒。ON状態のみ、緑にする。
        rect_cell.fill = "green"
      elsif(mode == 'white' && s == '0') #同様にOFF状態のみ白にする。
        rect_cell.fill = "white"
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
  file_path = set_file_name_sticker()
  canvas.write(file_path);
  r = file_path
end

def set_file_name_sticker()
  ymdhms = Time.now.strftime("%Y%m%d%H%M%S")
  file_name = "stkr" + ymdhms + ".png"
  dir_name = ENV['HOME'] + "/www/wetsteam/lifegamebot/tmpimg"
  if( !FileTest::exist?(dir_name) )
    FileUtils.mkdir_p(dir_name)
  end
  path = dir_name + "/" + file_name
end
  

def send_wear(png, gene, step)
  p png
  p gene
  p step
end


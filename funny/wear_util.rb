#!/usr/bin/ruby
require 'cairo'

def get_state_text(gene, step)
  p gene
  p step
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
  img_format = Cairo::FORMAT_ARGB32
  size_cell = 50;
  spc_cell = 10;
  num_cells = 10;
  spc_frame = 40;
  len_img = size_cell * num_cells + spc_cell * ( num_cells - 1 ) + 2 * spc_frame
  surface = Cairo::ImageSurface.new(img_format, len_img, len_img)
  context = Cairo::Context.new(surface)
  num_cells.times do |y|
    y0 = spc_frame + y * ( size_cell + spc_cell )
    y1 = y0 * size_cell
    num_cells.times do |x|
      x0 = spc_frame + x * ( size_cell + spc_cell )
      x1 = x0 + size_cell
      context.fill do
        if(mode == 'black')
          context.set_source_rgb(0, 0, 0)
        else
          context.set_source_rgb(1, 1, 1)
        end
        context.rectangle(x0, y0, x1, y1)
      end
      context.stroke do
        if(mode == 'black')
          context.set_source_rgb(0, 1, 0)
        else
          context.set_source_rgb(0, 0, 0)
        end
      end
    end
  end
  surface.write_to_png("test.png");
  p state
  p mode
  return "nyan"
end

def send_wear(png, gene, step)
  p png
  p gene
  p step
end


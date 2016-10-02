#!/usr/bin/ruby

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

def convert_img(state)
  p state
  return "nyan"
end

def send_wear(png, gene, step)
  p png
  p gene
  p step
end


#!/home/ikatake/local/rbenv/shims/ruby

#ライフゲームbot用の便利関数たち。

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



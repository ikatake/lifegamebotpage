#!/home/ikatake/local/rbenv/shims/ruby

#ライフゲームbot用の便利関数たち。

def get_state_text(gene, step)
  # set filename
  genestr = sprintf("%08d", gene)
  stepstr = sprintf("%08d", step)
  filename = "/home/ikatake/www/wetsteam/lifegamebot/stateLogs/"
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

def get_lastest_gene_step()
  filename = "/home/ikatake/local/twlg/state.txt"
  file = File.open(filename)
  text = file.read
  file.close
  lines = text.split(/\n/)
  arr = lines[10].split(/\t/)
  gene = arr[1].to_i
  arr = lines[11].split(/\t/)
  step = arr[1].to_i
  arr = [gene, step]
  return arr
end

def get_lastest_state_text()
  filename = "/home/ikatake/local/twlg/state.txt"
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

def is_valid_gene_step?(gene, step)
  arr = get_lastest_gene_step()
  cur_gene = arr[0]
  cur_step = arr[1]
  if gene > cur_gene
    return false
  end
  if gene == cur_gene
    if step > cur_step
      return false
    else
      return true
    end
  end
  if step > measure_gene(gene)
    return false
  else
    return true
  end
end

def measure_gene(gene)
  dir_path = '/home/ikatake/www/wetsteam/lifegamebot/stateLogs/'
  dir_path << sprintf("%08d/", gene) 
  if ( FileTest.exist?(dir_path) && FileTest.directory?(dir_path) ) == false
    return -1;
  end
  arr = Dir.glob(dir_path + "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].txt")
  return arr.size
end
  



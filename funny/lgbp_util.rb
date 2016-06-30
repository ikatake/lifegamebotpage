#!/usr/local/bin/ruby

require 'File'

#指定されたperiodの長さを返す。
#無い場合は-1を返す。
def measure(age)
  parent_dir_name = "/home/ikatake/www/wetsteam/lifegamebot/stateLogs/"
  dir_name = File.join(parent_dir_name, "%08d" % age)
  return_value = 0;
  unless(FileTest.exit(dir_name))
    return_value = -1
    return
  end
  dir = Dir.open(dir_name)
  file_array = Dir.glob("#{dir_name}/*.txt")
  return_value = file_array.size
  return
end

class LifeGameState
  def initialize(gene = 0, step = 0, state="")
    @gene = gene
    @step = step
    state_str(state)
  end
  def state_str(state)
    return if(state == "")
    lines = state.split("\n")
    @states = Array.new(lines.length)
    lines.each_with_index do |line, i|
      @state[i] = line.split("")
    end
  end
end




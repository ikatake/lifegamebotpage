#!/usr/bin/env /home/ikatake/local/rbenv/shims/ruby
###!/bin/usr/local/ruby

#モノづくりcgi共有化

require_relative './lgb_util.rb'
require_relative './suzuri_util.rb'
require_relative './draw_can_badge.rb'
require_relative './draw_t_shirt.rb'
require_relative './draw_hoodie.rb'
require_relative './draw_sticker.rb'
require_relative './draw_handkerchief.rb'
require 'cgi'
require 'date'
include Math

cgi = CGI.new
print "Content-Type: text/html\n\n"
print "<html><head><title>Now making...Please wait.</title></head><body>\n"
text = CGI.escapeHTML cgi["t"]
print text
print "<br>"

#read arguments
hs = Hash.new
#read argument (material)
if (cgi.has_key?("material") == false)
  r = Random.rand(4)
  if(r >= 5)
    material = "handkerchief"
  elsif(r >= 4)
    material = "hoodie"
  elsif(r >= 3)
    material = "can_badge"
  elsif(r >= 2)
    material = "sticker"
  else
    material = "t_shirt"
  end
else
  material = cgi["material"]
end
#read argument (color)
if (cgi.has_key?('color')  == false) 
  if(Random.rand(2) >= 1)
    color = "black"
  else
    color = "white"
  end
else
  color = cgi["color"]
end
#read argument (gene and step)
#set default parameter
state = get_lastest_state_text
arr = get_lastest_gene_step
gene = arr[0]
step = arr[1]
if (cgi.has_key?("gene"))
  #min(gene, gene_input) 
  gene = (gene < cgi["gene"].to_i) ? gene : cgi["gene"].to_i
  step = measure_gene(gene) - 1
end
if (cgi.has_key?("step"))
  #min(step, step_input)
  step = (step < cgi["step"].to_i) ? step : cgi["step"].to_i
end
state = get_state_text(gene, step)
	puts "#{material}<br>#{gene}<br>#{step}<br>#{color}<br>"
	puts "#{is_valid_gene_step?(gene, step)}<br>"
	puts "#{state}<br>"
file_name = "product_img/" + material + "_" + gene.to_s + "_" + step.to_s + "_"
file_name += Time.now.to_i.to_s + ".png"
	p file_name
img_address = "http://www.wetsteam.org/lifegamebot/" + file_name
hs = {"gene" => gene, "step" => step, "state" => state,
  "color" => color, "material" => material}
if (material == "sticker")
  draw_sticker(file_name, gene, step, color, state)
elsif (material == "can_badge")
  draw_can_badge(file_name, gene, step, color, state)
elsif (material == "t_shirt")
  draw_t_shirt(file_name, gene, step, color, state)
elsif ( material == "hoodie")
  draw_hoodie(file_name, gene, step, color, state)
elsif (material == "handkerchief")
  draw_handkerchief(file_name, gene, step, color, state)
end

print %Q{<span style="color:white"}
ret = suzuri( img_address, gene, step, color, material)
print %Q{</span>}
p ret
if(ret[0] == "3" || ret[0] == "4" || ret[0] == "5")
  print "</br>生成に失敗しました。さようなら。</br>\n"
  print %Q{<script type="text/javascript">\n}
  print %Q{<!-- \nwindow.open('about:_blank','_self').close()\n -->\n}
  print %Q{</script>\n}
else
  print %Q{<script type="text/javascript">\n}
  print %Q{<!-- \nwindow.location.href='#{ret}'\n -->\n}
  print %Q{</script>\n}
end
print "</body></html>\n"


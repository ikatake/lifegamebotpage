#!/usr/local/bin/ruby

require "cgi"
require "./wear_util"
require 'cairo'

cgi = CGI.new
params = cgi.params
p params;
#gene = params['gene'][0].to_i
#step = params['step'][0].to_i

#def wear_process()
#  g = @cgi["gene"]
#  s = @cgi["step"]

#  p g;
#  p s;
#  usrmgr.msg="a";

#end


#state = get_state_text(gene, step)

#png = convert_img(state)

#result = send_wear(png, gene, step);







format = Cairo::FORMAT_ARGB32
width = 300
height = 200
radius = height / 3

surface = Cairo::ImageSurface.new(format, width, height)
context = Cairo::Context.new(surface)

context.set_source_rgb(1, 1, 1)
context.rectangle(0, 0, width, height)
context.fill

context.set_source_rgb(1, 0, 0)
context.arc(width / 2, height / 2, radius, 0, 2 * Math::PI)
context.fill

surface.write_to_png("hinomaru.png")

#!/usr/local/bin/ruby


print "Content-Type: text/html\n\n"
print "<html><head><title>nyan</title></head><body>\n"

#str = ENV['QUERY_STRING']
#print str

c = CGI.new
text = CGI.escapeHTML c["t"]
print text
print "<br>"

#arr1 = str.split("&")
#print arr1[0]
#print "<br>"
#print arr1[1]
#print "<br>"

#arr2 = arr1[0].split("=")
#print arr2[1]

print "</body></html>\n"


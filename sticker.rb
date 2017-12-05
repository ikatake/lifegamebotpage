#!usr/local/bin/ruby

##!/home/ikatake/local/rbenv/shims/ruby

#ステッカー作成用cgi

#require_relative './suzuri_util.rb'
require_relative './lgb_util.rb'
require 'cgi'
require 'date'
require 'cairo'
require 'faraday'

#str = ENV['QUERY_STRING']
#print str

print "Content-Type: text/html\n\n"
print "<html><head><title>nyan</title></head><body>\n"
cgi = CGI.new
text = CGI.escapeHTML cgi["t"]
print text
print "<br>"

if (cgi.has_key?('color')  == false) 
  print "invalid parameters.(need 'color')."
  print "</body></html>\n"
  exit 0
end
if (cgi.has_key?('gene') ^ cgi.has_key?('step'))
  print "invalud parameters.(need both 'gene' and 'step')"
  print "</body></html>\n"
  exit 0
end

#read argument (color)
if(cgi['color'] == "black")
  color = "black"
else
  color = "white"
end

#read argument (gene and step)
if (cgi.has_key?('gene') && cgi.has_key?('step'))
  gene = cgi['gene'].to_i
  step = cgi['step'].to_i
  p measure_gene(gene)
  if( is_valid_gene_step?(gene, step) == false)
    print "invalid gene or step."
    print "</body></html>\n"
    exit 0
  end
  state = get_state_text(gene, step)
else #nothing gene & step => get lastst state
  state = get_lastest_state_text
  arr = get_lastest_gene_step
  gene = arr[0]
  step = arr[1]
end
	p state

#make iamge file
file_name = "tmp/" + gene.to_s + "_" + step.to_s + "_"
file_name += Time.now.to_i.to_s + ".png"
	p file_name
format = Cairo::FORMAT_ARGB32
width = 630
height = 630
surface = Cairo::ImageSurface.new(format, width, height)
context = Cairo::Context.new(surface)

cell_size = 50
cell_margin = 10
line_width = 2
top_margin = 15
left_margin = 15
line_width = 4

#fill background color(black only)
context.rectangle(0, 0, width, height)
context.set_source_rgb(0, 0, 0,)
context.fill

context.translate(top_margin, left_margin)
context.set_line_width(line_width)
arr = state.split(/\\n/)
for line in arr do
  charr = line.split("")
  for ch in charr do
    context.rectangle(0, 0, cell_size, cell_size)
    if(ch == "0")
      #draw white rectangle
      #context.set_source_rgb(1, 1, 1)
    elsif(ch == "1")
      #draw black rectangle
      if(color == "white") 
        context.set_source_rgb(0, 0, 0)
      elsif(color == "black")
        context.set_source_rgb(0, 1, 0)
      end
      context.fill_preserve
    end
    if(color == "white") 
      context.set_source_rgb(0, 0, 0)
    elsif(color == "black")
      context.set_source_rgb(0, 1, 0)
    end
    context.stroke
    # 1セル分右にずらす
    context.translate( (cell_size + cell_margin), 0)
  end
  #左右位置を元に戻して、1段下にずらす。
  context.translate( -(cell_size + cell_margin) * charr.length, 0)
  context.translate( 0, (cell_size + cell_margin) )
end

surface.write_to_png(file_name)

print "</body></html>\n"
#send to suzuri

def send_sticker()
  return
  conn = Faraday::Connection.new(:url => 'https://suzuri.jp/') do
  |builder|
    builder.use Faraday::Request::UrlEncoded
    builder.use Faraday::Response::Logger
    builder.use Faraday::Adapter::NetHttp
  end

  response = conn.post do |request|
    request.url  'api/v1/materials'
    request.headers['Authorization'] = 'Bearer 3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76'
    request.headers['Content-Type'] = 'application/json'
    request.body = '{
      "title": "@_lifegamebot g:1 s:1",
      "texture": "http://www.wetsteam.org/lifegamebot/tmpimg/1_1.png",
      "price": 0,
      "description": "@_lifegamebot g:1 s:1 sticker",
      "products": 
      [{
        "itemId": 11,
        "published": true,
        "resizeMoed": "contain"
      }]
    }'
  end
  json = JSON.parser.new(response.body)
  p json.parse
  #and so on.

end





#!/home/ikatake/local/rbenv/shims/ruby

#ステッカー作成用cgi

require_relative './suzuri_util.rb'
require 'cgi'


#str = ENV['QUERY_STRING']
#print str

print "Content-Type: text/html\n\n"
print "<html><head><title>nyan</title></head><body>\n"
cgi = CGI.new
text = CGI.escapeHTML cgi["t"]
print text
print "<br>"

if cgi.has_key?('lastest') || (cgi.has_key?('gene') && cgi.has_key?('step'))
  print "invalid parameters.(need 'lastest' or 'gene' & 'step'."
  break
end

#read argument (latest)]
if cgi['lastest'] == 'on'
  state = get_lastest_state_text
  arr = get_lastest_gene_step
  gene = arr[0]
  step = arr[1]
else
#read argument (gene and step)
#check parameters
  gene = cgi['gene']
  step = cgi['step']
  if( is_valid_gene_step?(gene, step) == false)
    print "invalid gene or step."
    break
  end
end
p gene
p step
#get state

#make iamge file

#send to suzuri

#and so on.

print "</body></html>\n"





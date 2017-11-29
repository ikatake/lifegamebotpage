#!usr/local/bin/ruby

##!/home/ikatake/local/rbenv/shims/ruby

#ステッカー作成用cgi

require_relative './suzuri_util.rb'
require_relative './lgb_util.rb'
require 'cgi'


#str = ENV['QUERY_STRING']
#print str

print "Content-Type: text/html\n\n"
print "<html><head><title>nyan</title></head><body>\n"
cgi = CGI.new
text = CGI.escapeHTML cgi["t"]
print text
print "<br>"

if (cgi.has_key?('lastest') || (cgi.has_key?('gene') && cgi.has_key?('step'))) == false 
  print "invalid parameters.(need 'lastest' or 'gene' & 'step')."
  return
end

#read argument (latest)]
if cgi.has_key?('lastest')
  state = get_lastest_state_text
  arr = get_lastest_gene_step
  gene = arr[0]
  step = arr[1]
  p state
  p gene
  p step
  return
end

#read argument (gene and step)
#check parameters
gene = cgi['gene'].to_i
step = cgi['step'].to_i
p measure_gene(gene)
if( is_valid_gene_step?(gene, step) == false)
  print "invalid gene or step."
  return
end

#get state
state = get_state_text(gene, step)
p state

#make iamge file

#send to suzuri

#and so on.

print "</body></html>\n"





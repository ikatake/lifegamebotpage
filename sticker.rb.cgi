#!/home/ikatake/local/rbenv/shims/ruby

#ステッカー作成用cgi

require_relative './wear_util.rb'
require 'cgi'


#str = ENV['QUERY_STRING']
#print str








print "Content-Type: text/html\n\n"
print "<html><head><title>nyan</title></head><body>\n"
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





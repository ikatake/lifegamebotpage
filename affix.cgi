#!/usr/local/bin/ruby

require 'cgi'

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





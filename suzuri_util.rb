#!/bin/ruby

require 'json';
require 'faraday'

conn = Faraday::Connection.new(:url => 'https://suzuri.jp/') do
|builder|
  builder.use Faraday::Request::UrlEncoded
  builder.use Faraday::Response::Logger
  builder.use Faraday::Adapter::NetHttp
end

#response = conn.get do |request|
#  request.url  'api/v1/items'
#  request.headers['Authorization'] = 'Bearer 3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76'
#  request.headers['Content-Type'] = 'application/json'
##  request.body = JSON.generate(param)
#end
#json = JSON.parser.new(response.body)
#p json.parse

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
#p response.body
json = JSON.parser.new(response.body)
p "\n===\n"

p json.parse



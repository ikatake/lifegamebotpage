#!/bin/ruby

require 'json';
require 'faraday'

def suzuri(img_path, gene, step, material)
  conn = Faraday::Connection.new(:url => 'https://suzuri.jp/') do |builder|
    builder.use Faraday::Request::UrlEncoded
    builder.use Faraday::Response::Logger
    builder.use Faraday::Adapter::NetHttp
  end
  key = '3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76'

  if(material == "sticker")
    products = [{
      "itemId": 11,
      "published": true,
      "resizeMode": "contain"
    }]
  end

  response = conn.post do |request|
    request.url  'api/v1/materials'
    request.headers['Authorization'] = 'Bearer ' & key
    request.headers['Content-Type'] = 'application/json'
    request.body = '{
      "title": "@_lifegamebot g:" & gene & " s:" & step",
      "texture": img_path,
      "price": 0,
      "description": "@_lifegamebot g:"& gene &" s:" & step & " " & material,
      "products": products
    }'
  end
  #p response.body
  json = JSON.parser.new(response.body)

  p json.parse
  #get next view address
  return suzuri_address
end

def suzuri_connect_test()
  response = conn.get do |request|
    request.url  'api/v1/items'
    request.headers['Authorization'] = 'Bearer 3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76'
    request.headers['Content-Type'] = 'application/json'
  end
  json = JSON.parser.new(response.body)
  p json.parse
end

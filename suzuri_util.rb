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
  title = '"@_lifegamebot g:' + gene.to_s + ' s:' + step.to_s + '"'
  description = '"@_lifegamebot g:' + gene.to_s + ' s:' + step.to_s +
    ' ' + material + '"'
  texture = '"' + img_path + '"'

  if(material == "sticker")
    products = '[{
      "itemId": 11, "published": true, "resizeMode": "contain"
    }]'
  end
  response = conn.post do |request|
    request.url 'api/v1/materials'
    request.headers['Authorization'] = 'Bearer ' + key
    request.headers['Content-Type'] = 'application/json'
    request.body = '{
      "title": ' + title + ',
      "texture": ' + texture + ',
      "price": 0,
      "description": ' +  description + ',
      "products": ' + products +
    '}'
  end
  ret = response.status.to_s
  if(ret == "200")
    json = JSON.parser.new(response.body)
    body =json.parse
    ret = body["products"][0]["sampleUrl"]
  end
  #get next view address
  return ret
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


def send_sticker_test()
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
  p request
  end
  json = JSON.parser.new(response.body)
  p json.parse
  #and so on.

end

#send_sticker


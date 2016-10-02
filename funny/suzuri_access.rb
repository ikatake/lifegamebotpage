#!/bin/ruby

require 'json';
require 'faraday'

conn = Faraday::Connection.new(:url => 'https://suzuri.jp/') do
|builder|
  builder.use Faraday::Request::UrlEncoded
  builder.use Faraday::Response::Logger
  builder.use Faraday::Adapter::NetHttp
end

response = conn.get do |request|
  request.url  'api/v1/items'
  request.headers['Authorization'] = 'Bearer 3df61022350585b2e5a2890ef9cdd2201ef5897c50f655cd618fe90b8bac3c76'
  request.headers['Content-Type'] = 'application/json'
#  request.body = JSON.generate(param)
end
json = JSON.parser.new(response.body)
p json.parse




require 'sinatra'
require 'httparty'
require 'readthis'

cache = Readthis::Cache.new(
  expires_in: 1209600,
  refresh: true,
  redis: { url: ENV.fetch('REDIS_URL') }
)

get '/v1' do
  content_type :json
  headers "Access-Control-Allow-Origin" => "*"

  url = URI.parse request.query_string

  cache.fetch "v1/#{url}" do
    response = HTTParty.get url, format: :xml
    response.parsed_response.to_json
  end
end

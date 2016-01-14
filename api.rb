require 'json'
require 'sinatra'

records = []

get '/' do
  records.to_json
end

get '/sleep' do
  sleep 0.5
  "awake"
end

post '/' do
  record = request.body.read
  records << record
  "Added new record: #{record}"
end

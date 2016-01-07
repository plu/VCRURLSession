require 'json'
require 'sinatra'

records = []

get '/' do
  records.to_json
end

post '/' do
  record = request.body.read
  records << record
  "Added new record: #{record}"
end

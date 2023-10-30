require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  
  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  
  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)
  
  # convert the raw request to a string
  raw_data_string = raw_data.to_s
  
  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  symbols = parsed_data.fetch("currencies")
  @symbols = symbols.keys

  # render a view template where I show the symbols
  erb(:homepage)

end

get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  symbols = parsed_data.fetch("currencies")
  @symbols = symbols.keys

  # some more code to parse the URL and render a view template
  erb(:from_currency)

end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @destination_currency = params.fetch("to_currency")

  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  @conversion = parsed_data.fetch("result")

  # some more code to parse the URL and render a view template
  erb(:to_currency)

end

require 'bundler'
require 'json'

Bundler.require

DataMapper.setup(:default, "sqlite:///#{[Dir.pwd, '/db/stocks.db'].join}")

require_relative 'services/stock_info'
require_relative 'models/stock'

get '/style.css' do
  scss :style
end

get '/' do
  @stock_results = []

  #Stock.all.each do |stock|
  #  @stock_results << StockInfo.new(stock.symbol)
  #end

  haml :show
end

get '/stocks' do
  content_type :json
  StockInfo.new(params[:symbol]).to_hash.to_json
end

post '/stocks/new' do
  Stock.new(symbol: params[:stock_symbol]).save

  redirect '/'
end

delete '/stocks/:id' do |id|
  if stock = Stock.get(params[:id])
    stock.destroy
  end
end
